import 'package:flutter/material.dart';
import 'package:doodlevox_mobile/styles/dv_button_style.dart';
import 'package:doodlevox_mobile/widgets/shared/dv_snackbar.dart';

class DVPrimaryIconButton extends StatelessWidget {
  const DVPrimaryIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = 52,
    this.iconSize = 24,
    this.isLoading = false,
    this.disabled = false,
    this.feedbackMessage,
    this.feedbackPosition = DVSnackbarPosition.top,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final double size;
  final double iconSize;
  final bool isLoading;
  final bool disabled;
  final String? feedbackMessage;
  final DVSnackbarPosition feedbackPosition;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).extension<DVButtonStyle>()!;
    final isDisabled = disabled || isLoading;

    return GestureDetector(
      onTap: isDisabled && feedbackMessage != null
          ? () => DVSnackbar.show(
                context,
                message: feedbackMessage!,
                type: DVSnackbarType.info,
                duration: const Duration(seconds: 2),
                position: feedbackPosition,
              )
          : null,
      child: SizedBox(
        width: size,
        height: size,
        child: ElevatedButton(
          onPressed: isDisabled ? null : onPressed,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            backgroundColor: style.primaryButtonColor,
            foregroundColor: style.primaryButtonTextColor,
            disabledBackgroundColor: style.disabledButtonColor,
            disabledForegroundColor: style.disabledButtonTextColor,
            shape: style.buttonShape,
          ),
          child: isLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: style.primaryButtonTextColor,
                  ),
                )
              : Icon(icon, size: iconSize),
        ),
      ),
    );
  }
}
