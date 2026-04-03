import 'dart:io';
import 'dart:async';
import 'package:record/record.dart';
import 'package:logging/logging.dart';
import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';

enum RecordingState { idle, recording, recorded, playing, paused }

class DVAudioProvider extends ChangeNotifier {
  final _log = Logger('DVAudioProvider');
  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _player = AudioPlayer();

  RecordingState _state = RecordingState.idle;
  String? _recordingPath;
  Duration _recordingDuration = Duration.zero;
  Duration _playbackPosition = Duration.zero;
  Duration _playbackDuration = Duration.zero;
  Timer? _durationTimer;
  StreamSubscription<Amplitude>? _amplitudeSub;

  /// Normalized amplitude samples collected during recording (0.0 – 1.0).
  final List<double> _waveformSamples = [];

  /// The latest live amplitude (0.0 – 1.0), updated ~20×/sec while recording.
  double _currentAmplitude = 0.0;

  // Debounce guard
  bool _isBusy = false;

  RecordingState get state => _state;
  String? get recordingPath => _recordingPath;
  Duration get recordingDuration => _recordingDuration;
  Duration get playbackPosition => _playbackPosition;
  Duration get playbackDuration => _playbackDuration;
  bool get hasRecording => _recordingPath != null && _state != RecordingState.idle;
  List<double> get waveformSamples => _waveformSamples;
  double get currentAmplitude => _currentAmplitude;

  DVAudioProvider() {
    _player.onPlayerComplete.listen((_) {
      _state = RecordingState.recorded;
      _playbackPosition = Duration.zero;
      notifyListeners();
    });
    _player.onPositionChanged.listen((position) {
      _playbackPosition = position;
      notifyListeners();
    });
    _player.onDurationChanged.listen((duration) {
      _playbackDuration = duration;
      notifyListeners();
    });
  }

  Future<void> startRecording() async {
    if (_isBusy) return;
    _isBusy = true;

    try {
      if (await _recorder.hasPermission()) {
        final dir = await getApplicationDocumentsDirectory();
        final path =
            '${dir.path}/dv_recording_${DateTime.now().millisecondsSinceEpoch}.m4a';

        await _recorder.start(
          const RecordConfig(
            encoder: AudioEncoder.aacLc,
            sampleRate: 44100,
            bitRate: 128000,
          ),
          path: path,
        );

        _recordingPath = path;
        _recordingDuration = Duration.zero;
        _waveformSamples.clear();
        _currentAmplitude = 0.0;
        _state = RecordingState.recording;

        _durationTimer = Timer.periodic(const Duration(seconds: 1), (_) {
          _recordingDuration += const Duration(seconds: 1);
          notifyListeners();
        });

        // Stream amplitude from the recorder (~20 samples/sec).
        _amplitudeSub = _recorder
            .onAmplitudeChanged(const Duration(milliseconds: 50))
            .listen((amp) {
          // amp.current is in dBFS (negative, with 0 = max).
          // Normalize to 0.0–1.0 using a -60 dB floor.
          final double db = amp.current;
          final double normalized =
              ((db + 60.0) / 60.0).clamp(0.0, 1.0);
          _currentAmplitude = normalized;
          _waveformSamples.add(normalized);
          notifyListeners();
        });

        _log.fine('Recording started at $path');
        notifyListeners();
      } else {
        _log.warning('Microphone permission denied');
      }
    } catch (e) {
      _log.severe('Failed to start recording: $e');
    } finally {
      _isBusy = false;
    }
  }

  Future<void> stopRecording() async {
    if (_isBusy) return;
    _isBusy = true;

    try {
      _durationTimer?.cancel();
      _durationTimer = null;
      await _amplitudeSub?.cancel();
      _amplitudeSub = null;
      _currentAmplitude = 0.0;

      final path = await _recorder.stop();
      if (path != null) {
        _recordingPath = path;
        _state = RecordingState.recorded;
        _log.fine('Recording stopped: $path');
      }
      notifyListeners();
    } catch (e) {
      _log.severe('Failed to stop recording: $e');
    } finally {
      _isBusy = false;
    }
  }

  Future<void> playRecording() async {
    if (_isBusy || _recordingPath == null) return;
    _isBusy = true;

    try {
      await _player.play(DeviceFileSource(_recordingPath!));
      _state = RecordingState.playing;
      _log.fine('Playing recording');
      notifyListeners();
    } catch (e) {
      _log.severe('Failed to play recording: $e');
    } finally {
      _isBusy = false;
    }
  }

  Future<void> pausePlayback() async {
    if (_isBusy) return;
    _isBusy = true;

    try {
      await _player.pause();
      _state = RecordingState.paused;
      _log.fine('Playback paused');
      notifyListeners();
    } catch (e) {
      _log.severe('Failed to pause playback: $e');
    } finally {
      _isBusy = false;
    }
  }

  Future<void> resumePlayback() async {
    if (_isBusy) return;
    _isBusy = true;

    try {
      await _player.resume();
      _state = RecordingState.playing;
      _log.fine('Playback resumed');
      notifyListeners();
    } catch (e) {
      _log.severe('Failed to resume playback: $e');
    } finally {
      _isBusy = false;
    }
  }

  Future<void> stopPlayback() async {
    try {
      await _player.stop();
      _state = RecordingState.recorded;
      _playbackPosition = Duration.zero;
      notifyListeners();
    } catch (e) {
      _log.severe('Failed to stop playback: $e');
    }
  }

  Future<void> recordAgain() async {
    if (_isBusy) return;
    _isBusy = true;

    try {
      // Stop any ongoing playback
      await _player.stop();

      // Delete previous recording file
      if (_recordingPath != null) {
        final file = File(_recordingPath!);
        if (await file.exists()) {
          await file.delete();
          _log.fine('Deleted previous recording: $_recordingPath');
        }
      }

      _recordingPath = null;
      _recordingDuration = Duration.zero;
      _playbackPosition = Duration.zero;
      _playbackDuration = Duration.zero;
      _waveformSamples.clear();
      _currentAmplitude = 0.0;
      _state = RecordingState.idle;
      notifyListeners();
    } catch (e) {
      _log.severe('Failed to reset recording: $e');
    } finally {
      _isBusy = false;
    }
  }

  @override
  void dispose() {
    _durationTimer?.cancel();
    _amplitudeSub?.cancel();
    _recorder.dispose();
    _player.dispose();
    super.dispose();
  }
}
