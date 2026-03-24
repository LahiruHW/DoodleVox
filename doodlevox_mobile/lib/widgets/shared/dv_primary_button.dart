import 'package:flutter/material.dart';
import 'package:doodlevox_mobile/styles/dv_button_style.dart';
import 'package:doodlevox_mobile/widgets/shared/dv_snackbar.dart';

enum DvPrimaryButtonFeedbackPosition { top, bottom }

class DVPrimaryButton extends StatelessWidget {
  const DVPrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.disabled = false,
    this.feedbackMessage,
    this.feedbackPosition = .top,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool disabled;
  final String? feedbackMessage;
  final DvPrimaryButtonFeedbackPosition feedbackPosition;

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
              position: feedbackPosition == .top ? .top : .bottom,
            )
          : null,
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: isDisabled ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: style.primaryButtonColor,
            foregroundColor: style.primaryButtonTextColor,
            disabledBackgroundColor: style.disabledButtonColor,
            disabledForegroundColor: style.disabledButtonTextColor,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
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
              : Row(
                  mainAxisAlignment: .center,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, size: 20),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      label,
                      style: style.buttonTextStyle.copyWith(
                        color: isDisabled
                            ? style.disabledButtonTextColor
                            : null,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
