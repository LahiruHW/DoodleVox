import 'package:flutter/material.dart';
import 'package:doodlevox_mobile/styles/dv_snackbar_style.dart';

enum DVSnackbarType { info, error, success }

enum DVSnackbarPosition { top, bottom }

class DVSnackbar {
  static void show(
    BuildContext context, {
    required String message,
    DVSnackbarType type = .info,
    DVSnackbarPosition position = .bottom,
    Duration duration = const Duration(seconds: 3),
  }) {
    final style = Theme.of(context).extension<DVSnackbarStyle>()!;

    Color bgColor;
    Color textColor;
    IconData icon;

    switch (type) {
      case DVSnackbarType.error:
        bgColor = style.errorBackgroundColor;
        textColor = style.errorTextColor;
        icon = Icons.error_outline;
        break;
      case DVSnackbarType.success:
        bgColor = style.successBackgroundColor;
        textColor = style.successTextColor;
        icon = Icons.check_circle_outline;
        break;
      case DVSnackbarType.info:
        bgColor = style.backgroundColor;
        textColor = style.textColor;
        icon = Icons.info_outline;
        break;
    }

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: textColor, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: style.textStyle.copyWith(color: textColor),
              ),
            ),
          ],
        ),
        backgroundColor: bgColor,
        behavior: position == .top
            ? SnackBarBehavior.floating
            : SnackBarBehavior.fixed,
        margin: position == .top
            ? EdgeInsets.only(
                left: 10,
                right: 10,
                bottom: MediaQuery.of(context).size.height - 240,
              )
            : null,
        shape: const RoundedRectangleBorder(borderRadius: .zero),
        duration: duration,
      ),
    );
  }
}
