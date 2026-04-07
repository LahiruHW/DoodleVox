import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:doodlevox_mobile/models/dv_recording.dart';
import 'package:doodlevox_mobile/widgets/shared/dv_snackbar.dart';
import 'package:doodlevox_mobile/screens/library/library_tile.dart';
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
            return LibraryTile(
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


