import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Paints a glowing beam that sweeps around the rounded-rect border.
class BorderBeamPainter extends CustomPainter {
  /// 0.0 → 1.0, position of the beam head along perimeter
  final double progress;

  /// Base color of the beam
  ///
  /// (alpha is modulated by the painter to create the fading tail)
  final Color color;

  const BorderBeamPainter({
    required this.progress,
    required this.color,
  });

  /// Must match the container's BorderRadius so the beam follows the rounded corners.
  static const _borderRadius = 12.0;

  /// Stroke width of the beam. Adjust as needed to fit the design.
  static const _strokeWidth = 2.0;

  /// Fraction of the total perimeter that the beam tail occupies (0.0–1.0).
  static const _beamFraction = 0.50;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(
      rect,
      const Radius.circular(_borderRadius),
    );

    // The gradient is defined once: opaque at 0° (head), fading to transparent
    // at _beamFraction × 360° (tail), then transparent for the rest of the circle.
    // GradientRotation advances the head around the border as progress increases.
    // -π/2 offsets the 3-o'clock origin of SweepGradient to 12 o'clock.
    //
    // Because only the transform changes per frame (not the stop structure),
    // there is no seam-crossing branch and no mid-animation gradient discontinuity.
    final gradient = SweepGradient(
      center: Alignment.center,
      colors: [
        color.withValues(alpha: 0.0), // tail: transparent
        color.withValues(alpha: 0.0), // rest of circle: transparent
        color, // head: opaque (at 0° of gradient)
      ],
      stops: [0.0, _beamFraction, 1.0],
      transform: GradientRotation(2 * math.pi * progress - math.pi / 2),
    );

    canvas.drawRRect(
      rrect,
      Paint()
        ..shader = gradient.createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = _strokeWidth
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(BorderBeamPainter old) => old.progress != progress;
}
