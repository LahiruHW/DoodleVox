import 'package:flutter/material.dart';
import 'package:doodlevox_mobile/models/dv_recording.dart';
import 'package:doodlevox_mobile/widgets/dv_waveform.dart';
import 'package:doodlevox_mobile/styles/dv_library_screen_style.dart';

class LibraryTile extends StatefulWidget {
  /// A single recording entry in the library list, showing title, duration, and a mini waveform preview.
  const LibraryTile({
    super.key,
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
  State<LibraryTile> createState() => _LibraryTileState();
}

class _LibraryTileState extends State<LibraryTile> {
  bool _isEditing = false;
  late TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.recording.title);
  }

  @override
  void didUpdateWidget(LibraryTile old) {
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
