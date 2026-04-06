import 'dart:io';
import 'dart:convert';
import 'package:logging/logging.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:doodlevox_mobile/models/dv_recording.dart';

/// Manages the local library of audio recordings with JSON-file persistence.
class DVLibraryProvider extends ChangeNotifier {
  final _log = Logger('DVLibraryProvider');

  static const String _fileName = 'dv_library.json';

  List<DVRecording> _recordings = [];
  bool _isLoaded = false;

  /// The recording slot currently in use by the record screen.
  /// While non-null the record screen will update this entry instead of
  /// creating a new one.
  String? _currentSlotId;

  // ---------------------------------------------------------------------------
  // Public getters
  // ---------------------------------------------------------------------------

  /// All recordings, newest first.
  List<DVRecording> get recordings => List.unmodifiable(_recordings);

  bool get isLoaded => _isLoaded;

  String? get currentSlotId => _currentSlotId;

  // ---------------------------------------------------------------------------
  // Slot management (used by the record screen)
  // ---------------------------------------------------------------------------

  /// Returns the current slot ID, or creates a new one if none exists.
  String getOrCreateSlotId() {
    _currentSlotId ??= DVRecording.generateId();
    return _currentSlotId!;
  }

  /// Clears the current slot so the next recording creates a fresh entry.
  void finaliseSlot() {
    _currentSlotId = null;
  }

  // ---------------------------------------------------------------------------
  // CRUD
  // ---------------------------------------------------------------------------

  /// Load recordings from persistent JSON file.  Call once at app startup.
  Future<void> loadRecordings() async {
    try {
      final file = await _jsonFile();
      if (await file.exists()) {
        final contents = await file.readAsString();
        final List<dynamic> list = jsonDecode(contents) as List<dynamic>;
        _recordings = list
            .map((e) => DVRecording.fromJson(e as Map<String, dynamic>))
            .toList();
        // Newest first.
        _recordings.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        _log.info('Loaded ${_recordings.length} recordings from disk');
      }
    } catch (e) {
      _log.severe('Failed to load library: $e');
    }
    _isLoaded = true;
    notifyListeners();
  }

  /// Save or update a recording in the library.
  ///
  /// If a recording with the same [DVRecording.id] already exists it is
  /// updated in-place; otherwise the recording is inserted at the front.
  Future<void> saveRecording(DVRecording recording) async {
    final idx = _recordings.indexWhere((r) => r.id == recording.id);
    if (idx >= 0) {
      // Update existing slot — keep position but replace data.
      _recordings[idx] = recording;
    } else {
      _recordings.insert(0, recording);
    }
    notifyListeners();
    await _persist();
    _log.fine('Saved recording ${recording.id}');
  }

  /// Update just the title of a recording and flag it for sync if needed.
  Future<void> updateTitle(String id, String newTitle) async {
    final recording = _recordings.firstWhere(
      (r) => r.id == id,
      orElse: () => throw StateError('Recording $id not found'),
    );
    recording.title = newTitle;
    recording.updatedAt = DateTime.now();
    if (recording.syncStatus == DVSyncStatus.synced) {
      recording.syncStatus = DVSyncStatus.pendingSync;
    }
    notifyListeners();
    await _persist();
    _log.fine('Updated title for $id');
  }

  /// Delete a recording from the library and remove the audio file from disk.
  Future<void> deleteRecording(String id) async {
    final idx = _recordings.indexWhere((r) => r.id == id);
    if (idx < 0) return;

    final recording = _recordings[idx];

    // If this is the active slot, clear it.
    if (_currentSlotId == id) {
      _currentSlotId = null;
    }

    _recordings.removeAt(idx);
    notifyListeners();
    await _persist();

    // Remove the audio file from disk.
    try {
      final file = File(recording.filePath);
      if (await file.exists()) {
        await file.delete();
        _log.fine('Deleted audio file: ${recording.filePath}');
      }
    } catch (e) {
      _log.warning('Could not delete audio file: $e');
    }
  }

  /// Mark a recording as sent to DAW.
  Future<void> markSentToDaw(String id) async {
    final recording = _recordings.firstWhere(
      (r) => r.id == id,
      orElse: () => throw StateError('Recording $id not found'),
    );
    recording.syncStatus = DVSyncStatus.synced;
    recording.updatedAt = DateTime.now();
    notifyListeners();
    await _persist();
    _log.fine('Marked $id as sent to DAW');
  }

  /// Look up a recording by ID.
  DVRecording? getRecording(String id) {
    try {
      return _recordings.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Returns recordings that have been sent to DAW and need syncing.
  List<DVRecording> get pendingSyncRecordings =>
      _recordings.where((r) => r.syncStatus == DVSyncStatus.pendingSync).toList();

  /// Returns all recordings that have been sent to DAW (synced or pending).
  List<DVRecording> get dawRecordings =>
      _recordings.where((r) => r.syncStatus != DVSyncStatus.localOnly).toList();

  // ---------------------------------------------------------------------------
  // Persistence helpers
  // ---------------------------------------------------------------------------

  Future<File> _jsonFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_fileName');
  }

  Future<void> _persist() async {
    try {
      final file = await _jsonFile();
      final json = jsonEncode(_recordings.map((r) => r.toJson()).toList());
      await file.writeAsString(json);
    } catch (e) {
      _log.severe('Failed to persist library: $e');
    }
  }
}
