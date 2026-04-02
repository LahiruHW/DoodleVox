import 'package:flutter/material.dart';

class DVAlertDialog {
  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required Widget content,
    String confirmText = 'OK',
    String? cancelText,
    bool barrierDismissible = true,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: content,
        titlePadding: .all(20),
        contentPadding: .only(left: 20, right: 20, top: 0, bottom: 0),
        actions: [
          if (cancelText != null)
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(cancelText),
            ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }
}
