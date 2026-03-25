import 'package:flutter/material.dart';

class DVLogo extends StatelessWidget {
  const DVLogo({
    super.key,
    this.size = 150,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    final luminance = Theme.of(context).colorScheme.surface.computeLuminance();
    final isLightMode = luminance > 0.5;
    final img = 'dv_icon_1_${isLightMode ? 'light' : 'dark'}_transparent.png';
    return FittedBox(
      fit: .contain,
      child: Image.asset(
        'assets/images/icon/$img',
        width: size,
        height: size,
      ),
    );
  }
}
