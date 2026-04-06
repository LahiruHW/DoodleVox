import 'package:flutter/material.dart';
import 'package:doodlevox_mobile/styles/dv_colors.dart';
import 'package:doodlevox_mobile/styles/dv_text_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DVButtonStyle extends ThemeExtension<DVButtonStyle> {
  const DVButtonStyle({
    required this.primaryButtonColor,
    required this.primaryButtonTextColor,
    required this.secondaryButtonColor,
    required this.secondaryButtonTextColor,
    required this.secondaryButtonBorderColor,
    required this.disabledButtonColor,
    required this.disabledButtonTextColor,
    required this.buttonTextStyle,
    required this.buttonShape,
  });

  final Color primaryButtonColor;
  final Color primaryButtonTextColor;
  final Color secondaryButtonColor;
  final Color secondaryButtonTextColor;
  final Color secondaryButtonBorderColor;
  final Color disabledButtonColor;
  final Color disabledButtonTextColor;
  final TextStyle buttonTextStyle;
  final OutlinedBorder buttonShape;

  static DVButtonStyle light = DVButtonStyle(
    primaryButtonColor: DVColors.primary,
    primaryButtonTextColor: DVColors.neutral,
    secondaryButtonColor: Colors.transparent,
    secondaryButtonTextColor: DVColors.neutral,
    secondaryButtonBorderColor: DVColors.neutral,
    disabledButtonColor: Color(0xFFE0E0E0),
    disabledButtonTextColor: DVColors.tertiary,
    buttonTextStyle: DVTextTheme.titleStyle.copyWith(
      fontSize: 16.spMin,
      fontWeight: .w600,
    ),
    buttonShape: RoundedRectangleBorder(borderRadius: .all(.circular(25.r))),
  );

  static DVButtonStyle dark = DVButtonStyle(
    primaryButtonColor: DVColors.primary,
    primaryButtonTextColor: DVColors.neutral,
    secondaryButtonColor: Colors.transparent,
    secondaryButtonTextColor: DVColors.secondary,
    secondaryButtonBorderColor: DVColors.secondary,
    disabledButtonColor: Color(0xFF333333),
    disabledButtonTextColor: DVColors.tertiary,
    buttonTextStyle: DVTextTheme.titleStyle.copyWith(
      fontSize: 16.spMin,
      fontWeight: .w600,
    ),
    buttonShape: RoundedRectangleBorder(borderRadius: .all(.circular(25.r))),
  );

  @override
  ThemeExtension<DVButtonStyle> copyWith({
    Color? primaryButtonColor,
    Color? primaryButtonTextColor,
    Color? secondaryButtonColor,
    Color? secondaryButtonTextColor,
    Color? secondaryButtonBorderColor,
    Color? disabledButtonColor,
    Color? disabledButtonTextColor,
    TextStyle? buttonTextStyle,
    OutlinedBorder? buttonShape,
  }) {
    return DVButtonStyle(
      primaryButtonColor: primaryButtonColor ?? this.primaryButtonColor,
      primaryButtonTextColor:
          primaryButtonTextColor ?? this.primaryButtonTextColor,
      secondaryButtonColor: secondaryButtonColor ?? this.secondaryButtonColor,
      secondaryButtonTextColor:
          secondaryButtonTextColor ?? this.secondaryButtonTextColor,
      secondaryButtonBorderColor:
          secondaryButtonBorderColor ?? this.secondaryButtonBorderColor,
      disabledButtonColor: disabledButtonColor ?? this.disabledButtonColor,
      disabledButtonTextColor:
          disabledButtonTextColor ?? this.disabledButtonTextColor,
      buttonTextStyle: buttonTextStyle ?? this.buttonTextStyle,
      buttonShape: buttonShape ?? this.buttonShape,
    );
  }

  @override
  ThemeExtension<DVButtonStyle> lerp(
    covariant ThemeExtension<DVButtonStyle>? other,
    double t,
  ) {
    if (other is! DVButtonStyle) return this;
    return DVButtonStyle(
      primaryButtonColor: Color.lerp(
        primaryButtonColor,
        other.primaryButtonColor,
        t,
      )!,
      primaryButtonTextColor: Color.lerp(
        primaryButtonTextColor,
        other.primaryButtonTextColor,
        t,
      )!,
      secondaryButtonColor: Color.lerp(
        secondaryButtonColor,
        other.secondaryButtonColor,
        t,
      )!,
      secondaryButtonTextColor: Color.lerp(
        secondaryButtonTextColor,
        other.secondaryButtonTextColor,
        t,
      )!,
      secondaryButtonBorderColor: Color.lerp(
        secondaryButtonBorderColor,
        other.secondaryButtonBorderColor,
        t,
      )!,
      disabledButtonColor: Color.lerp(
        disabledButtonColor,
        other.disabledButtonColor,
        t,
      )!,
      disabledButtonTextColor: Color.lerp(
        disabledButtonTextColor,
        other.disabledButtonTextColor,
        t,
      )!,
      buttonTextStyle: TextStyle.lerp(
        buttonTextStyle,
        other.buttonTextStyle,
        t,
      )!,
      buttonShape:
          ShapeBorder.lerp(buttonShape, other.buttonShape, t)
              as OutlinedBorder? ??
          buttonShape,
    );
  }
}
