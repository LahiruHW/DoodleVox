import 'package:flutter/material.dart';
import 'package:doodlevox_mobile/styles/dv_button_style.dart';
import 'package:doodlevox_mobile/widgets/shared/dv_snackbar.dart';

class DVSecondaryButton extends StatelessWidget {
  const DVSecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.disabled = false,
    this.feedbackMessage,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool disabled;
  final String? feedbackMessage;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).extension<DVButtonStyle>()!;

    return GestureDetector(
      onTap: disabled && feedbackMessage != null
          ? () => DVSnackbar.show(
                context,
                message: feedbackMessage!,
                type: DVSnackbarType.info,
                duration: const Duration(seconds: 2),
              )
          : null,
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: OutlinedButton(
          onPressed: disabled ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: disabled
                ? style.disabledButtonTextColor
                : style.secondaryButtonTextColor,
            disabledForegroundColor: style.disabledButtonTextColor,
            side: BorderSide(
              color: disabled
                  ? style.disabledButtonTextColor
                  : style.secondaryButtonBorderColor,
            ),
            shape: style.buttonShape,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: style.buttonTextStyle.copyWith(
                  color: disabled
                      ? style.disabledButtonTextColor
                      : style.secondaryButtonTextColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
