import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A waveform visualizer driven by a list of amplitude samples.
///
/// • **Idle** (empty [samples]) — draws a flat center line.
/// • **Recording** — bars grow from the center, smoothly scrolling left as new
///   samples arrive so the latest sample is always at the right edge.
/// • **Playback** — the full recorded waveform is shown; [progress] (0.0–1.0)
///   tints completed bars with [activeColor] and remaining bars with
///   [inactiveColor].
class DVWaveform extends StatefulWidget {
  const DVWaveform({
    super.key,
    required this.samples,
    required this.activeColor,
    required this.inactiveColor,
    this.progress,
    this.barWidth = 3.0,
    this.barSpacing = 2.0,
    this.height = 80.0,
  });

  /// Normalized amplitude samples (each 0.0 – 1.0).
  final List<double> samples;

  /// Color for the "played" portion of the waveform (or live bars).
  final Color activeColor;

  /// Color for the "unplayed" portion.
  final Color inactiveColor;

  /// Playback progress from 0.0 to 1.0. When `null`, all bars use
  /// [activeColor] (live‑recording mode).
  final double? progress;

  final double barWidth;
  final double barSpacing;
  final double height;

  @override
  State<DVWaveform> createState() => _DVWaveformState();
}

class _DVWaveformState extends State<DVWaveform>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scrollCtrl;
  int _prevSampleCount = 0;

  @override
  void initState() {
    super.initState();
    _scrollCtrl = AnimationController(
      vsync: this,
      // Slightly longer than the 50 ms sample interval so the animation
      // finishes just as (or just after) the next sample lands — no jank.
      duration: const Duration(milliseconds: 80),
    );
    _prevSampleCount = widget.samples.length;
  }

  @override
  void didUpdateWidget(DVWaveform old) {
    super.didUpdateWidget(old);
    final isLive = widget.progress == null && widget.samples.isNotEmpty;
    if (isLive && widget.samples.length != _prevSampleCount) {
      _prevSampleCount = widget.samples.length;
      _scrollCtrl.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: double.infinity,
      child: AnimatedBuilder(
        animation: _scrollCtrl,
        builder: (context, _) => CustomPaint(
          painter: _WaveformPainter(
            samples: widget.samples,
            activeColor: widget.activeColor,
            inactiveColor: widget.inactiveColor,
            progress: widget.progress,
            barWidth: widget.barWidth,
            barSpacing: widget.barSpacing,
            scrollFraction: widget.progress == null ? _scrollCtrl.value : 1.0,
          ),
        ),
      ),
    );
  }
}

class _WaveformPainter extends CustomPainter {

  /// Custom painter that draws the waveform bars based on the provided samples and
  /// playback progress. It handles both live recording (smoothly scrolling bars)
  /// and static playback (resampled bars with progress tint).
  _WaveformPainter({
    required this.samples,
    required this.activeColor,
    required this.inactiveColor,
    required this.progress,
    required this.barWidth,
    required this.barSpacing,
    required this.scrollFraction,
  });

  final List<double> samples;
  final Color activeColor;
  final Color inactiveColor;
  final double? progress;
  final double barWidth;
  final double barSpacing;

  /// 0.0 → new sample just arrived (bars haven't scrolled yet).
  /// 1.0 → bars have scrolled left by one full step.
  final double scrollFraction;

  @override
  void paint(Canvas canvas, Size size) {
    final centerY = size.height / 2;
    final step = barWidth + barSpacing;
    final maxBars = (size.width / step).floor();

    // ── Idle state: draw a thin horizontal center line ──
    if (samples.isEmpty) {
      final paint = Paint()
        ..color = inactiveColor
        ..strokeWidth = 1.5
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(
        Offset(0, centerY),
        Offset(size.width, centerY),
        paint,
      );
      return;
    }

    final minBarHeight = 3.0;
    final activePaint = Paint()
      ..color = activeColor
      ..strokeWidth = barWidth
      ..strokeCap = StrokeCap.round;
    final inactivePaint = Paint()
      ..color = inactiveColor
      ..strokeWidth = barWidth
      ..strokeCap = StrokeCap.round;

    final bool isLive = progress == null;

    if (isLive) {
      // ── Live recording: smooth-scrolling bars ──
      // Grab one extra sample so a new bar can slide in from the right.
      final count = math.min(samples.length, maxBars + 1);
      final start = samples.length - count;
      final visible = samples.sublist(start);

      final totalWidth = visible.length * step;
      // Base offset right-aligns the bars; scrollFraction drives the
      // smooth leftward shift by one step (0 → not scrolled, 1 → fully
      // scrolled). Clipping hides bars that overflow.
      final baseOffset = size.width - totalWidth;
      final animatedOffset = baseOffset + (1.0 - scrollFraction) * step;

      canvas.save();
      canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

      for (int i = 0; i < visible.length; i++) {
        final amp = visible[i];
        final halfBar = math.max(
          minBarHeight / 2,
          amp * (size.height / 2 - 2),
        );
        final x = animatedOffset + i * step + barWidth / 2;
        canvas.drawLine(
          Offset(x, centerY - halfBar),
          Offset(x, centerY + halfBar),
          activePaint,
        );
      }

      canvas.restore();
    } else {
      // ── Playback: static resampled waveform with progress tint ──
      final visible = _resample(samples, maxBars);
      final totalWidth = visible.length * step;
      final offsetX = (size.width - totalWidth) / 2;

      for (int i = 0; i < visible.length; i++) {
        final amp = visible[i];
        final halfBar = math.max(
          minBarHeight / 2,
          amp * (size.height / 2 - 2),
        );
        final x = offsetX + i * step + barWidth / 2;
        final fraction = i / visible.length;
        final paint = fraction <= progress! ? activePaint : inactivePaint;

        canvas.drawLine(
          Offset(x, centerY - halfBar),
          Offset(x, centerY + halfBar),
          paint,
        );
      }
    }
  }

  /// Resample [source] into exactly [count] buckets by averaging.
  static List<double> _resample(List<double> source, int count) {
    if (count <= 0) return [];
    if (source.length <= count) return List.of(source);

    final result = List<double>.filled(count, 0.0);
    final ratio = source.length / count;
    for (int i = 0; i < count; i++) {
      final start = (i * ratio).floor();
      final end = math.min(((i + 1) * ratio).ceil(), source.length);
      double sum = 0;
      for (int j = start; j < end; j++) {
        sum += source[j];
      }
      result[i] = sum / (end - start);
    }
    return result;
  }

  @override
  bool shouldRepaint(_WaveformPainter oldDelegate) => true;
}
