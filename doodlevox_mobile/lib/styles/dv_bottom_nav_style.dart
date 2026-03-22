import 'package:flutter/material.dart';
import 'package:doodlevox_mobile/styles/dv_themes.dart';

class DVBottomNavStyle extends ThemeExtension<DVBottomNavStyle> {
  const DVBottomNavStyle({
    required this.backgroundColor,
    required this.selectedItemColor,
    required this.unselectedItemColor,
    required this.selectedLabelStyle,
    required this.unselectedLabelStyle,
  });

  final Color backgroundColor;
  final Color selectedItemColor;
  final Color unselectedItemColor;
  final TextStyle selectedLabelStyle;
  final TextStyle unselectedLabelStyle;

  static const DVBottomNavStyle light = DVBottomNavStyle(
    backgroundColor: Colors.white,
    selectedItemColor: DVTheme.primaryColor,
    unselectedItemColor: DVTheme.tertiaryColor,
    selectedLabelStyle: TextStyle(
      fontFamily: 'Inter',
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: DVTheme.primaryColor,
    ),
    unselectedLabelStyle: TextStyle(
      fontFamily: 'Inter',
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: DVTheme.tertiaryColor,
    ),
  );

  static const DVBottomNavStyle dark = DVBottomNavStyle(
    backgroundColor: DVTheme.neutralColor,
    selectedItemColor: DVTheme.primaryColor,
    unselectedItemColor: DVTheme.tertiaryColor,
    selectedLabelStyle: TextStyle(
      fontFamily: 'Inter',
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: DVTheme.primaryColor,
    ),
    unselectedLabelStyle: TextStyle(
      fontFamily: 'Inter',
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: DVTheme.tertiaryColor,
    ),
  );

  @override
  ThemeExtension<DVBottomNavStyle> copyWith({
    Color? backgroundColor,
    Color? selectedItemColor,
    Color? unselectedItemColor,
    TextStyle? selectedLabelStyle,
    TextStyle? unselectedLabelStyle,
  }) {
    return DVBottomNavStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      selectedItemColor: selectedItemColor ?? this.selectedItemColor,
      unselectedItemColor: unselectedItemColor ?? this.unselectedItemColor,
      selectedLabelStyle: selectedLabelStyle ?? this.selectedLabelStyle,
      unselectedLabelStyle: unselectedLabelStyle ?? this.unselectedLabelStyle,
    );
  }

  @override
  ThemeExtension<DVBottomNavStyle> lerp(
    covariant ThemeExtension<DVBottomNavStyle>? other,
    double t,
  ) {
    if (other is! DVBottomNavStyle) return this;
    return DVBottomNavStyle(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      selectedItemColor:
          Color.lerp(selectedItemColor, other.selectedItemColor, t)!,
      unselectedItemColor:
          Color.lerp(unselectedItemColor, other.unselectedItemColor, t)!,
      selectedLabelStyle:
          TextStyle.lerp(selectedLabelStyle, other.selectedLabelStyle, t)!,
      unselectedLabelStyle:
          TextStyle.lerp(unselectedLabelStyle, other.unselectedLabelStyle, t)!,
    );
  }
}
