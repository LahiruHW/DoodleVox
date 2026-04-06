import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:doodlevox_mobile/models/dv_recording.dart';
import 'package:doodlevox_mobile/widgets/dv_waveform.dart';
import 'package:doodlevox_mobile/widgets/shared/dv_snackbar.dart';
import 'package:doodlevox_mobile/providers/dv_library_provider.dart';
import 'package:doodlevox_mobile/styles/dv_library_screen_style.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final AudioPlayer _previewPlayer = AudioPlayer();
  String? _playingId;

  @override
  void initState() {
    super.initState();
    _previewPlayer.onPlayerComplete.listen((_) {
      setState(() => _playingId = null);
    });
  }

  @override
  void dispose() {
    _previewPlayer.dispose();
    super.dispose();
  }

  Future<void> _togglePreview(DVRecording recording) async {
    if (_playingId == recording.id) {
      await _previewPlayer.stop();
      setState(() => _playingId = null);
    } else {
      await _previewPlayer.stop();
      await _previewPlayer.play(DeviceFileSource(recording.filePath));
      setState(() => _playingId = recording.id);
    }
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).extension<DVLibraryScreenStyle>()!;

    return Consumer<DVLibraryProvider>(
      builder: (context, library, _) {
        if (!library.isLoaded) {
          return const Center(child: CircularProgressIndicator());
        }

        if (library.recordings.isEmpty) {
          return _buildEmptyState(style);
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: library.recordings.length,
          itemBuilder: (context, index) {
            final recording = library.recordings[index];
            return _LibraryTile(
              recording: recording,
              style: style,
              isPlaying: _playingId == recording.id,
              onTogglePreview: () => _togglePreview(recording),
              onDelete: () => _confirmDelete(context, library, recording),
              onTitleChanged: (newTitle) {
                library.updateTitle(recording.id, newTitle);
              },
              formatDuration: _formatDuration,
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState(DVLibraryScreenStyle style) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.library_music_outlined,
              size: 64,
              color: style.emptyIconColor,
            ),
            const SizedBox(height: 16),
            Text('No recordings yet', style: style.emptyTextStyle),
            const SizedBox(height: 8),
            Text(
              'Recordings will appear here after you record a sample.',
              style: style.emptyTextStyle.copyWith(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    DVLibraryProvider library,
    DVRecording recording,
  ) async {
    // Stop preview if this recording is playing.
    if (_playingId == recording.id) {
      await _previewPlayer.stop();
      setState(() => _playingId = null);
    }

    if (!context.mounted) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Recording'),
        content: Text('Delete "${recording.title}"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              'Delete',
              style: TextStyle(color: Theme.of(context).extension<DVLibraryScreenStyle>()!.deleteColor),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await library.deleteRecording(recording.id);
      if (context.mounted) {
        DVSnackbar.show(
          context,
          message: 'Recording deleted',
          type: DVSnackbarType.info,
        );
      }
    }
  }
}

// ---------------------------------------------------------------------------
// Individual library tile
// ---------------------------------------------------------------------------

class _LibraryTile extends StatefulWidget {
  const _LibraryTile({
    required this.recording,
    required this.style,
    required this.isPlaying,
    required this.onTogglePreview,
    required this.onDelete,
    required this.onTitleChanged,
    required this.formatDuration,
  });

  final DVRecording recording;
  final DVLibraryScreenStyle style;
  final bool isPlaying;
  final VoidCallback onTogglePreview;
  final VoidCallback onDelete;
  final ValueChanged<String> onTitleChanged;
  final String Function(Duration) formatDuration;

  @override
  State<_LibraryTile> createState() => _LibraryTileState();
}

class _LibraryTileState extends State<_LibraryTile> {
  bool _isEditing = false;
  late TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.recording.title);
  }

  @override
  void didUpdateWidget(_LibraryTile old) {
    super.didUpdateWidget(old);
    if (old.recording.title != widget.recording.title && !_isEditing) {
      _titleController.text = widget.recording.title;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _submitTitle() {
    final newTitle = _titleController.text.trim();
    if (newTitle.isNotEmpty && newTitle != widget.recording.title) {
      widget.onTitleChanged(newTitle);
    } else {
      _titleController.text = widget.recording.title;
    }
    setState(() => _isEditing = false);
  }

  @override
  Widget build(BuildContext context) {
    final rec = widget.recording;
    final style = widget.style;

    return Dismissible(
      key: ValueKey(rec.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: style.deleteColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      confirmDismiss: (_) async {
        widget.onDelete();
        return false; // The dialog handles actual deletion.
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: style.cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Title row ──
            Row(
              children: [
                Expanded(
                  child: _isEditing
                      ? TextField(
                          controller: _titleController,
                          autofocus: true,
                          style: style.titleTextStyle,
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            border: InputBorder.none,
                          ),
                          onSubmitted: (_) => _submitTitle(),
                          onTapOutside: (_) => _submitTitle(),
                        )
                      : GestureDetector(
                          onTap: () => setState(() => _isEditing = true),
                          child: Text(
                            rec.title,
                            style: style.titleTextStyle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                ),
                const SizedBox(width: 8),
                // Sync badge
                if (rec.isSentToDaw)
                  Icon(
                    rec.syncStatus == DVSyncStatus.synced
                        ? Icons.cloud_done_outlined
                        : Icons.cloud_upload_outlined,
                    size: 18,
                    color: style.syncBadgeColor,
                  ),
              ],
            ),
            const SizedBox(height: 4),
            // ── Duration ──
            Text(
              widget.formatDuration(rec.duration),
              style: style.subtitleTextStyle,
            ),
            const SizedBox(height: 10),
            // ── Waveform + play button ──
            Row(
              children: [
                GestureDetector(
                  onTap: widget.onTogglePreview,
                  child: Icon(
                    widget.isPlaying ? Icons.stop : Icons.play_arrow,
                    size: 28,
                    color: style.waveformColor,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DVWaveform(
                    samples: rec.waveformSamples,
                    activeColor: style.waveformColor,
                    inactiveColor: style.waveformInactiveColor,
                    progress: 1.0, // static full waveform
                    height: 40,
                    barWidth: 2.0,
                    barSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
