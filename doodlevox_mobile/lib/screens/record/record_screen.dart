import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
// import 'package:flutter_animate/flutter_animate.dart';
import 'package:doodlevox_mobile/models/dv_recording.dart';
import 'package:doodlevox_mobile/widgets/dv_waveform.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:doodlevox_mobile/utils/dv_shared_prefs.dart';
import 'package:doodlevox_mobile/providers/dv_daw_provider.dart';
import 'package:doodlevox_mobile/widgets/shared/dv_snackbar.dart';
import 'package:doodlevox_mobile/providers/dv_audio_provider.dart';
import 'package:doodlevox_mobile/providers/dv_library_provider.dart';
import 'package:doodlevox_mobile/styles/dv_record_screen_style.dart';
import 'package:doodlevox_mobile/widgets/shared/dv_primary_button.dart';
import 'package:doodlevox_mobile/widgets/shared/dv_secondary_button.dart';
import 'package:doodlevox_mobile/widgets/shared/dv_secondary_icon_button.dart';

class RecordScreen extends StatelessWidget {
  const RecordScreen({super.key});

  static String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  /// Save (or update) the current recording into the library.
  Future<void> _saveToLibrary(
    DVAudioProvider audio,
    DVLibraryProvider library,
  ) async {
    if (audio.recordingPath == null) return;

    final slotId = library.getOrCreateSlotId();
    final now = DateTime.now();
    final existing = library.getRecording(slotId);

    final recording = DVRecording(
      id: slotId,
      title: existing?.title ?? DVRecording.defaultTitle(now),
      filePath: audio.recordingPath!,
      waveformSamples: List<double>.from(audio.waveformSamples),
      durationMs: audio.recordingDuration.inMilliseconds,
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
      syncStatus: existing?.syncStatus ?? DVSyncStatus.localOnly,
      encoding: existing?.encoding ?? DVSharedPrefs.getEncoding(),
    );

    await library.saveRecording(recording);
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).extension<DVRecordScreenStyle>()!;

    return Consumer3<DVAudioProvider, DVDawProvider, DVLibraryProvider>(
      builder: (context, audio, daw, library, _) {
        final isRecording = audio.state == .recording;
        final hasRecording = audio.hasRecording;
        final isPlaying = audio.state == .playing;
        final isPaused = audio.state == .paused;
        final isDawConnected = daw.isConnected;
        final isSending = daw.state == .sending;

        return Padding(
          padding: const .symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 2),
              // Recording indicator
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: .circle,
                  color: isRecording
                      ? style.recordingIndicatorColor
                      : style.idleIndicatorColor,
                ),
              ),
              const SizedBox(height: 8),
              // Status label
              Text(
                isRecording
                    ? 'Recording...'
                    : isPlaying
                    ? 'Playing'
                    : isPaused
                    ? 'Paused'
                    : hasRecording
                    ? 'Recorded'
                    : 'Ready',
                style: style.statusTextStyle,
              ),
              const SizedBox(height: 16),

              // Waveform display
              DVWaveform(
                samples: audio.waveformSamples,
                activeColor: style.waveformColor,
                inactiveColor: style.idleIndicatorColor.withValues(alpha: 0.4),
                progress: isRecording
                    ? null // live mode — no progress bar
                    : (isPlaying || isPaused) &&
                            audio.playbackDuration.inMilliseconds > 0
                        ? audio.playbackPosition.inMilliseconds /
                            audio.playbackDuration.inMilliseconds
                        : hasRecording
                            ? 1.0
                            : null,
              ),
              const SizedBox(height: 8),

              // Timer display
              Text(
                isRecording
                    ? _formatDuration(audio.recordingDuration)
                    : (isPlaying || isPaused)
                    ? _formatDuration(audio.playbackPosition)
                    : hasRecording
                    ? _formatDuration(audio.recordingDuration)
                    : '00:00',
                style: style.timerTextStyle,
              ),
              const Spacer(flex: 2),
              // Playback controls (only after recording exists)
              if (hasRecording && !isRecording)
                Padding(
                  padding: const .only(bottom: 24),
                  child: Row(
                    mainAxisAlignment: .center,
                    children: [
                      // Play / Pause button
                      IconButton(
                        iconSize: 48.spMin,
                        color: style.playbackIconColor,
                        onPressed: () {
                          if (isPlaying) {
                            audio.pausePlayback();
                          } else {
                            if (isPaused) {
                              audio.resumePlayback();
                            } else {
                              audio.playRecording();
                            }
                          }
                        },
                        icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                      ),

                      IconButton(
                        iconSize: 40.spMin,
                        onPressed: () {
                          context.push('/record/effects');
                        },
                        icon: Icon(Icons.multitrack_audio_rounded),
                      ),
                    ],
                  ),
                ),
              // Main recording button
              if (!hasRecording || isRecording)
                DVPrimaryButton(
                  label: isRecording ? 'Stop Recording' : 'Start Recording',
                  icon: isRecording ? Icons.stop : Icons.mic,
                  onPressed: () async {
                    if (isRecording) {
                      await audio.stopRecording();
                      await _saveToLibrary(audio, library);
                    } else {
                      // Ensure a slot exists before recording.
                      library.getOrCreateSlotId();
                      audio.startRecording();
                    }
                  },
                ),
              // Action buttons (after recording)
              if (hasRecording && !isRecording) ...[
                Row(
                  spacing: 10,
                  children: [
                    // Record again button — keeps the same library slot.
                    DVSecondaryIconButton(
                      icon: Icons.refresh,
                      disabled: isSending,
                      onPressed: () {
                        daw.resetToConnected();
                        audio.recordAgain();
                        // Slot ID is intentionally NOT cleared — next recording
                        // overwrites the same library entry.
                      },
                    ),
                    // Start fresh button — clears the current slot so next recording creates a new entry.
                    Expanded(
                      child: DVSecondaryButton(
                        label: 'Start Fresh',
                        icon: Icons.check,
                        disabled: false,
                        onPressed: () {
                          daw.resetToConnected();
                          audio.recordAgain();
                          // Slot ID is  cleared — next recording is new
                          library.finaliseSlot();
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Send to DAW button
                DVPrimaryButton(
                  label: isSending
                      ? 'Sending...'
                      : daw.state == .sent
                      ? 'Sent to DAW ✓'
                      : 'Send to DAW',
                  icon: isSending
                      ? Icons.sync
                      : daw.state == .sent
                      ? Icons.check
                      : Icons.send,
                  isLoading: isSending,
                  disabled: !isDawConnected || isSending,
                  feedbackMessage: !isDawConnected
                      ? 'Not connected to DAW. Scan the QR code first.'
                      : null,
                  feedbackPosition: .top,
                  onPressed: () async {
                    if (audio.recordingPath == null) return;
                    final success = await daw.sendToDaw(audio.recordingPath!);
                    if (!context.mounted) return;
                    if (success) {
                      // Mark the recording as synced in the library.
                      final slotId = library.currentSlotId;
                      if (slotId != null) {
                        await library.markSentToDaw(slotId);
                      }
                      // Finalise the slot so next recording creates a new entry.
                      library.finaliseSlot();

                      if (!context.mounted) return;
                      DVSnackbar.show(
                        context,
                        message: 'Audio sent to DAW',
                        type: .success,
                      );
                    } else {
                      DVSnackbar.show(
                        context,
                        message: daw.errorMessage ?? 'Failed to send',
                        type: DVSnackbarType.error,
                        duration: const Duration(seconds: 4),
                      );
                    }
                  },
                ),
              ],
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }
}
