import 'dart:async';
import 'dart:convert';
import 'package:logging/logging.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:doodlevox_mobile/models/dv_recording.dart';
import 'package:doodlevox_mobile/providers/dv_daw_provider.dart';
import 'package:doodlevox_mobile/providers/dv_library_provider.dart';

/// Handles bidirectional metadata synchronisation between the mobile library
/// and the DAW plugin for recordings that exist on both sides.
///
/// Sync is performed over the same local-network connection established by
/// [DVDawProvider].  When the DAW is not connected, sync is disabled and the
/// library continues to function in offline-only mode.
///
/// ### Protocol (mobile ↔ DAW plugin)
///
/// **Endpoint:** `POST <serverUrl>/sync?token=<token>`
///
/// **Request body (JSON):**
/// ```json
/// {
///   "recordings": [
///     {
///       "id": "uuid",
///       "title": "...",
///       "updatedAt": "ISO-8601",
///       "deleted": false
///     }
///   ]
/// }
/// ```
///
/// **Response body (JSON):** same schema — the DAW's current view of each
/// recording it knows about.  The mobile app reconciles by taking the newer
/// `updatedAt` for each field.
class DVSyncProvider extends ChangeNotifier {
  final _log = Logger('DVSyncProvider');

  bool _isSyncing = false;
  DateTime? _lastSyncTime;
  String? _errorMessage;
  Timer? _syncTimer;

  bool get isSyncing => _isSyncing;
  DateTime? get lastSyncTime => _lastSyncTime;
  String? get errorMessage => _errorMessage;

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  /// Start the periodic sync loop.  Must be called after the DAW connection is
  /// established.  The loop runs every [interval] and is a no-op when the DAW
  /// is disconnected.
  void startPeriodicSync({
    required DVDawProvider daw,
    required DVLibraryProvider library,
    Duration interval = const Duration(seconds: 30),
  }) {
    stopPeriodicSync();
    _syncTimer = Timer.periodic(interval, (_) => sync(daw: daw, library: library));
    _log.info('Periodic sync started (every ${interval.inSeconds}s)');
  }

  void stopPeriodicSync() {
    _syncTimer?.cancel();
    _syncTimer = null;
  }

  // ---------------------------------------------------------------------------
  // One-shot sync
  // ---------------------------------------------------------------------------

  /// Perform a single sync cycle.
  ///
  /// 1.  Collect metadata for all recordings that have been sent to the DAW.
  /// 2.  POST the list to the DAW's `/sync` endpoint.
  /// 3.  Reconcile the DAW's response with the local library (latest
  ///     `updatedAt` wins for each field).
  Future<void> sync({
    required DVDawProvider daw,
    required DVLibraryProvider library,
  }) async {
    // Guard: only sync when connected to the DAW.
    if (!daw.isConnected || daw.serverUrl == null) {
      _log.fine('Skipping sync — DAW not connected');
      return;
    }

    if (_isSyncing) return;
    _isSyncing = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final dawRecordings = library.dawRecordings;
      if (dawRecordings.isEmpty) {
        _log.fine('No DAW recordings to sync');
        _isSyncing = false;
        notifyListeners();
        return;
      }

      // Build the request payload.
      final payload = {
        'recordings': dawRecordings.map((r) => {
              'id': r.id,
              'title': r.title,
              'updatedAt': r.updatedAt.toIso8601String(),
              'deleted': false,
            }).toList(),
      };

      final uri = Uri.parse('${daw.serverUrl}/sync?token=${daw.token}');
      final response = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(payload),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final Map<String, dynamic> body =
            jsonDecode(response.body) as Map<String, dynamic>;
        final List<dynamic> remoteList =
            body['recordings'] as List<dynamic>? ?? [];

        await _reconcile(remoteList, library);

        _lastSyncTime = DateTime.now();
        _log.info('Sync completed successfully');
      } else {
        _errorMessage = 'Sync failed (${response.statusCode})';
        _log.warning('Sync HTTP error: ${response.statusCode}');
      }
    } catch (e) {
      _errorMessage = 'Sync failed: $e';
      _log.warning('Sync error: $e');
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }

  // ---------------------------------------------------------------------------
  // Reconciliation
  // ---------------------------------------------------------------------------

  Future<void> _reconcile(
    List<dynamic> remoteList,
    DVLibraryProvider library,
  ) async {
    for (final item in remoteList) {
      final remote = item as Map<String, dynamic>;
      final id = remote['id'] as String;
      final remoteUpdated = DateTime.parse(remote['updatedAt'] as String);
      final remoteDeleted = remote['deleted'] as bool? ?? false;

      final local = library.getRecording(id);
      if (local == null) {
        // Recording was deleted locally but DAW still has it — nothing to do
        // on mobile side ( DAW will learn about the deletion on the next push).
        continue;
      }

      if (remoteDeleted) {
        // DAW deleted this recording — remove locally.
        await library.deleteRecording(id);
        _log.fine('Deleted $id per DAW instruction');
        continue;
      }

      // Latest updatedAt wins for title.
      if (remoteUpdated.isAfter(local.updatedAt)) {
        final remoteTitle = remote['title'] as String?;
        if (remoteTitle != null && remoteTitle != local.title) {
          await library.updateTitle(id, remoteTitle);
          // Reset sync status since we just applied the DAW's version.
          local.syncStatus = DVSyncStatus.synced;
          _log.fine('Applied remote title for $id');
        }
      } else if (local.syncStatus == DVSyncStatus.pendingSync) {
        // Local is newer — mark synced (we already pushed our version).
        local.syncStatus = DVSyncStatus.synced;
      }
    }
  }

  @override
  void dispose() {
    stopPeriodicSync();
    super.dispose();
  }
}
