import 'package:flutter/material.dart';
import 'package:doodlevox_mobile/styles/dv_button_style.dart';

class DVPrimaryButton extends StatelessWidget {
  const DVPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).extension<DVButtonStyle>()!;

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: style.primaryButtonColor,
          foregroundColor: style.primaryButtonTextColor,
          disabledBackgroundColor: style.disabledButtonColor,
          disabledForegroundColor: style.disabledButtonTextColor,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(label, style: style.buttonTextStyle),
                ],
              ),
      ),
    );
  }
}

class DVSecondaryButton extends StatelessWidget {
  const DVSecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).extension<DVButtonStyle>()!;

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: style.secondaryButtonTextColor,
          side: BorderSide(color: style.secondaryButtonBorderColor),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20),
              const SizedBox(width: 8),
            ],
            Text(label, style: style.buttonTextStyle.copyWith(
              color: style.secondaryButtonTextColor,
            )),
          ],
        ),
      ),
    );
  }
}

class DVDisabledButton extends StatelessWidget {
  const DVDisabledButton({
    super.key,
    required this.label,
    this.tooltip,
    this.icon,
  });

  final String label;
  final String? tooltip;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).extension<DVButtonStyle>()!;

    final button = SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: null,
        style: ElevatedButton.styleFrom(
          disabledBackgroundColor: style.disabledButtonColor,
          disabledForegroundColor: style.disabledButtonTextColor,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20),
              const SizedBox(width: 8),
            ],
            Text(label, style: style.buttonTextStyle.copyWith(
              color: style.disabledButtonTextColor,
            )),
          ],
        ),
      ),
    );

    if (tooltip != null) {
      return Tooltip(
        message: tooltip!,
        child: button,
      );
    }
    return button;
  }
}
