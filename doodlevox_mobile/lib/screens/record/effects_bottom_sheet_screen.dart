import 'package:flutter/material.dart';
import 'package:doodlevox_mobile/styles/dv_effects_sheet_style.dart';

class SheetScaffold extends StatelessWidget {
  const SheetScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).extension<DVEffectsSheetStyle>()!;

    return Scaffold(
      backgroundColor: style.backgroundColor,
      appBar: AppBar(elevation: 0),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 10,
            children: [
              Icon(
                Icons.multitrack_audio_rounded,
                size: 64,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.3),
              ),
              Text(
                'Audio Effects',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
              Text(
                'Coming soon',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
