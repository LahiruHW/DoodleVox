import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CupertinoSheetPage<T> extends Page<T> {
  final Widget child;
  const CupertinoSheetPage({required this.child, super.key});

  @override
  Route<T> createRoute(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final barrierColor = isDark
        ? Colors.white.withValues(alpha: 0.1)
        : Colors.black.withValues(alpha: 0.12);

    return _AdaptiveCupertinoSheetRoute<T>(
      settings: this,
      showDragHandle: true,
      enableDrag: false,
      adaptiveBarrierColor: barrierColor,
      builder: (_) => child,
    );
  }
}

class _AdaptiveCupertinoSheetRoute<T> extends CupertinoSheetRoute<T> {
  final Color adaptiveBarrierColor;

  _AdaptiveCupertinoSheetRoute({
    required super.builder,
    required this.adaptiveBarrierColor,
    super.settings,
    super.showDragHandle,
    super.enableDrag,
  });

  @override
  Color? get barrierColor => adaptiveBarrierColor;
}
