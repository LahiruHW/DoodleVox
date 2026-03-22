import 'package:flutter/material.dart';
import 'package:doodlevox_mobile/styles/dv_themes.dart';

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
  });

  final Color primaryButtonColor;
  final Color primaryButtonTextColor;
  final Color secondaryButtonColor;
  final Color secondaryButtonTextColor;
  final Color secondaryButtonBorderColor;
  final Color disabledButtonColor;
  final Color disabledButtonTextColor;
  final TextStyle buttonTextStyle;

  static const DVButtonStyle light = DVButtonStyle(
    primaryButtonColor: DVTheme.primaryColor,
    primaryButtonTextColor: DVTheme.neutralColor,
    secondaryButtonColor: Colors.transparent,
    secondaryButtonTextColor: DVTheme.neutralColor,
    secondaryButtonBorderColor: DVTheme.neutralColor,
    disabledButtonColor: Color(0xFFE0E0E0),
    disabledButtonTextColor: DVTheme.tertiaryColor,
    buttonTextStyle: TextStyle(
      fontFamily: 'Inter',
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
  );

  static const DVButtonStyle dark = DVButtonStyle(
    primaryButtonColor: DVTheme.primaryColor,
    primaryButtonTextColor: DVTheme.neutralColor,
    secondaryButtonColor: Colors.transparent,
    secondaryButtonTextColor: DVTheme.secondaryColor,
    secondaryButtonBorderColor: DVTheme.secondaryColor,
    disabledButtonColor: Color(0xFF333333),
    disabledButtonTextColor: DVTheme.tertiaryColor,
    buttonTextStyle: TextStyle(
      fontFamily: 'Inter',
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
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
    );
  }

  @override
  ThemeExtension<DVButtonStyle> lerp(
    covariant ThemeExtension<DVButtonStyle>? other,
    double t,
  ) {
    if (other is! DVButtonStyle) return this;
    return DVButtonStyle(
      primaryButtonColor:
          Color.lerp(primaryButtonColor, other.primaryButtonColor, t)!,
      primaryButtonTextColor:
          Color.lerp(primaryButtonTextColor, other.primaryButtonTextColor, t)!,
      secondaryButtonColor:
          Color.lerp(secondaryButtonColor, other.secondaryButtonColor, t)!,
      secondaryButtonTextColor: Color.lerp(
          secondaryButtonTextColor, other.secondaryButtonTextColor, t)!,
      secondaryButtonBorderColor: Color.lerp(
          secondaryButtonBorderColor, other.secondaryButtonBorderColor, t)!,
      disabledButtonColor:
          Color.lerp(disabledButtonColor, other.disabledButtonColor, t)!,
      disabledButtonTextColor:
          Color.lerp(disabledButtonTextColor, other.disabledButtonTextColor, t)!,
      buttonTextStyle:
          TextStyle.lerp(buttonTextStyle, other.buttonTextStyle, t)!,
    );
  }
}
