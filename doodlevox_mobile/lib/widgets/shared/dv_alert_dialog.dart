import 'package:flutter/material.dart';

class DVAlertDialog {
  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String content,
    String confirmText = 'OK',
    String? cancelText,
    bool barrierDismissible = true,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        contentPadding: .only(left: 20, right: 20, top: 10, bottom: 5),
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
