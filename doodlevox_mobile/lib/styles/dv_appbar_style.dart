import 'package:flutter/material.dart';
import 'package:doodlevox_mobile/styles/dv_themes.dart';

class DVAppBarStyle extends ThemeExtension<DVAppBarStyle> {
  const DVAppBarStyle({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.titleStyle,
  });

  final Color backgroundColor;
  final Color foregroundColor;
  final TextStyle titleStyle;

  static const DVAppBarStyle light = DVAppBarStyle(
    backgroundColor: Colors.white,
    foregroundColor: DVTheme.neutralColor,
    titleStyle: TextStyle(
      fontFamily: 'Inter',
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: DVTheme.neutralColor,
    ),
  );

  static const DVAppBarStyle dark = DVAppBarStyle(
    backgroundColor: DVTheme.neutralColor,
    foregroundColor: DVTheme.secondaryColor,
    titleStyle: TextStyle(
      fontFamily: 'Inter',
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: DVTheme.secondaryColor,
    ),
  );

  @override
  ThemeExtension<DVAppBarStyle> copyWith({
    Color? backgroundColor,
    Color? foregroundColor,
    TextStyle? titleStyle,
  }) {
    return DVAppBarStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      titleStyle: titleStyle ?? this.titleStyle,
    );
  }

  @override
  ThemeExtension<DVAppBarStyle> lerp(
    covariant ThemeExtension<DVAppBarStyle>? other,
    double t,
  ) {
    if (other is! DVAppBarStyle) return this;
    return DVAppBarStyle(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      foregroundColor: Color.lerp(foregroundColor, other.foregroundColor, t)!,
      titleStyle: TextStyle.lerp(titleStyle, other.titleStyle, t)!,
    );
  }
}
