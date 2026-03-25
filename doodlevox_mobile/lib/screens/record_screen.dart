import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doodlevox_mobile/providers/dv_daw_provider.dart';
import 'package:doodlevox_mobile/widgets/shared/dv_snackbar.dart';
import 'package:doodlevox_mobile/providers/dv_audio_provider.dart';
import 'package:doodlevox_mobile/styles/dv_record_screen_style.dart';
import 'package:doodlevox_mobile/widgets/shared/dv_primary_button.dart';
import 'package:doodlevox_mobile/widgets/shared/dv_secondary_button.dart';

class RecordScreen extends StatelessWidget {
  const RecordScreen({super.key});

  static String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).extension<DVRecordScreenStyle>()!;

    return Consumer2<DVAudioProvider, DVDawProvider>(
      builder: (context, audio, daw, _) {
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
              // Playback progress indicator
              if (hasRecording && audio.playbackDuration.inMilliseconds > 0)
                Padding(
                  padding: const .only(top: 16),
                  child: LinearProgressIndicator(
                    value: audio.playbackDuration.inMilliseconds > 0
                        ? audio.playbackPosition.inMilliseconds /
                            audio.playbackDuration.inMilliseconds
                        : 0,
                    backgroundColor: style.idleIndicatorColor.withValues(alpha: 0.3),
                    valueColor: AlwaysStoppedAnimation(style.waveformColor),
                    minHeight: 3,
                  ),
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
                        iconSize: 48,
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
                    ],
                  ),
                ),
              // Main recording button
              if (!hasRecording || isRecording)
                DVPrimaryButton(
                  label: isRecording ? 'Stop Recording' : 'Start Recording',
                  icon: isRecording ? Icons.stop : Icons.mic,
                  onPressed: () {
                    if (isRecording) {
                      audio.stopRecording();
                    } else {
                      audio.startRecording();
                    }
                  },
                ),
              // Action buttons (after recording)
              if (hasRecording && !isRecording) ...[
                DVSecondaryButton(
                  label: 'Record Again',
                  icon: Icons.refresh,
                  disabled: isSending,
                  onPressed: () {
                    daw.resetToConnected();
                    audio.recordAgain();
                  },
                ),
                const SizedBox(height: 12),
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
