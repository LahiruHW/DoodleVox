import 'package:flutter/material.dart';
import 'package:doodlevox_mobile/styles/dv_button_style.dart';
import 'package:doodlevox_mobile/widgets/shared/dv_snackbar.dart';

class DVSecondaryIconButton extends StatelessWidget {
  const DVSecondaryIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = 52,
    this.iconSize = 24,
    this.disabled = false,
    this.feedbackMessage,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final double size;
  final double iconSize;
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
        width: size,
        height: size,
        child: OutlinedButton(
          onPressed: disabled ? null : onPressed,
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.zero,
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
          child: Icon(icon, size: iconSize),
        ),
      ),
    );
  }
}
