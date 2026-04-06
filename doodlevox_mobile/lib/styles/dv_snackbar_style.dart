import 'package:flutter/material.dart';
import 'package:doodlevox_mobile/styles/dv_colors.dart';
import 'package:doodlevox_mobile/styles/dv_text_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DVSnackbarStyle extends ThemeExtension<DVSnackbarStyle> {
  const DVSnackbarStyle({
    required this.backgroundColor,
    required this.textColor,
    required this.errorBackgroundColor,
    required this.errorTextColor,
    required this.successBackgroundColor,
    required this.successTextColor,
    required this.textStyle,
  });

  final Color backgroundColor;
  final Color textColor;
  final Color errorBackgroundColor;
  final Color errorTextColor;
  final Color successBackgroundColor;
  final Color successTextColor;
  final TextStyle textStyle;

  static DVSnackbarStyle light = DVSnackbarStyle(
    backgroundColor: DVColors.neutral,
    textColor: DVColors.secondary,
    errorBackgroundColor: Color(0xFFFF3860),
    errorTextColor: DVColors.secondary,
    successBackgroundColor: Color(0xFF23D160),
    successTextColor: DVColors.neutral,
    textStyle: DVTextTheme.labelStyle.copyWith(fontSize: 14.spMin),
  );

  static DVSnackbarStyle dark = DVSnackbarStyle(
    backgroundColor: Color(0xFF333333),
    textColor: DVColors.secondary,
    errorBackgroundColor: Color(0xFFFF3860),
    errorTextColor: DVColors.secondary,
    successBackgroundColor: Color(0xFF23D160),
    successTextColor: DVColors.neutral,
    textStyle: DVTextTheme.labelStyle.copyWith(fontSize: 14.spMin),
  );

  @override
  ThemeExtension<DVSnackbarStyle> copyWith({
    Color? backgroundColor,
    Color? textColor,
    Color? errorBackgroundColor,
    Color? errorTextColor,
    Color? successBackgroundColor,
    Color? successTextColor,
    TextStyle? textStyle,
  }) {
    return DVSnackbarStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      errorBackgroundColor: errorBackgroundColor ?? this.errorBackgroundColor,
      errorTextColor: errorTextColor ?? this.errorTextColor,
      successBackgroundColor:
          successBackgroundColor ?? this.successBackgroundColor,
      successTextColor: successTextColor ?? this.successTextColor,
      textStyle: textStyle ?? this.textStyle,
    );
  }

  @override
  ThemeExtension<DVSnackbarStyle> lerp(
    covariant ThemeExtension<DVSnackbarStyle>? other,
    double t,
  ) {
    if (other is! DVSnackbarStyle) return this;
    return DVSnackbarStyle(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      textColor: Color.lerp(textColor, other.textColor, t)!,
      errorBackgroundColor: Color.lerp(
        errorBackgroundColor,
        other.errorBackgroundColor,
        t,
      )!,
      errorTextColor: Color.lerp(errorTextColor, other.errorTextColor, t)!,
      successBackgroundColor: Color.lerp(
        successBackgroundColor,
        other.successBackgroundColor,
        t,
      )!,
      successTextColor: Color.lerp(
        successTextColor,
        other.successTextColor,
        t,
      )!,
      textStyle: TextStyle.lerp(textStyle, other.textStyle, t)!,
    );
  }
}
