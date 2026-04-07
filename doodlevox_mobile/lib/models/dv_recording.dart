import 'dart:math';

/// Sync status of a recording relative to the DAW plugin.
enum DVSyncStatus {
  /// Recording exists only on mobile; never sent to DAW.
  localOnly,

  /// Recording has been sent to DAW and metadata is in sync.
  synced,

  /// Local metadata was changed after the last sync; needs push.
  pendingSync,
}

/// Data model that assigns an immutable ID for a single audio recording.
class DVRecording {
  DVRecording({
    required this.id,
    required this.title,
    required this.filePath,
    required this.waveformSamples,
    required this.durationMs,
    required this.createdAt,
    required this.updatedAt,
    this.syncStatus = DVSyncStatus.localOnly,
  });

  /// Unique, immutable identifier (UUID v4).
  final String id;

  /// User-facing title.  Defaults to the formatted recording date/time but
  /// may be edited by the user.
  String title;

  /// Absolute path to the .m4a audio file on disk.
  String filePath;

  /// Normalised amplitude samples (0.0 – 1.0) captured during recording,
  /// used to render the waveform visualisation in the library list.
  List<double> waveformSamples;

  /// Recording duration in milliseconds.
  int durationMs;

  /// When the recording was first created.
  final DateTime createdAt;

  /// When the recording metadata was last modified.
  DateTime updatedAt;

  /// Current synchronisation state with the DAW plugin.
  DVSyncStatus syncStatus;

  // ---------------------------------------------------------------------------
  // Convenience getters
  // ---------------------------------------------------------------------------

  Duration get duration => Duration(milliseconds: durationMs);

  bool get isSentToDaw => syncStatus != DVSyncStatus.localOnly;

  // ---------------------------------------------------------------------------
  // JSON serialisation
  // ---------------------------------------------------------------------------

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'filePath': filePath,
        'waveformSamples': waveformSamples,
        'durationMs': durationMs,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'syncStatus': syncStatus.name,
      };

  factory DVRecording.fromJson(Map<String, dynamic> json) {
    return DVRecording(
      id: json['id'] as String,
      title: json['title'] as String,
      filePath: json['filePath'] as String,
      waveformSamples:
          (json['waveformSamples'] as List<dynamic>).cast<num>().map((n) => n.toDouble()).toList(),
      durationMs: json['durationMs'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      syncStatus: DVSyncStatus.values.byName(
        (json['syncStatus'] as String?) ?? DVSyncStatus.localOnly.name,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // UUID v4 generator (no external dependency)
  // ---------------------------------------------------------------------------

  static String generateId() {
    final rng = Random.secure();
    final bytes = List<int>.generate(16, (_) => rng.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40; // version 4
    bytes[8] = (bytes[8] & 0x3f) | 0x80; // variant 1
    final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-'
        '${hex.substring(12, 16)}-${hex.substring(16, 20)}-'
        '${hex.substring(20)}';
  }

  /// Default title derived from the recording timestamp.
  static String defaultTitle(DateTime dateTime) {
    final d = dateTime;
    final month = _monthName(d.month);
    final day = d.day;
    final year = d.year;
    final hour = d.hour > 12 ? d.hour - 12 : (d.hour == 0 ? 12 : d.hour);
    final minute = d.minute.toString().padLeft(2, '0');
    final period = d.hour >= 12 ? 'PM' : 'AM';
    return '$month $day, $year  $hour:$minute $period';
  }

  static String _monthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return months[month - 1];
  }
}
