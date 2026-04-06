import 'package:flutter/material.dart';

class DVTextTheme {
  DVTextTheme._();

  static const TextStyle displayStyle = TextStyle(
    fontFamily: 'Inter',
    fontSize: 28,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle headlineStyle = TextStyle(
    fontFamily: 'Inter',
    fontSize: 24,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle titleStyle = TextStyle(
    fontFamily: 'Inter',
    fontSize: 20,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle labelStyle = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  // text hierarchy: display > headline > title > body > label

  static TextTheme globalTextTheme = TextTheme(
    displayLarge: DVTextTheme.displayStyle.copyWith(fontSize: 32),
    displayMedium: DVTextTheme.displayStyle.copyWith(fontSize: 28),
    displaySmall: DVTextTheme.displayStyle.copyWith(fontSize: 24),
    ///////////////////////////////////////////////////////////////////////
    headlineLarge: DVTextTheme.headlineStyle.copyWith(fontSize: 28),
    headlineMedium: DVTextTheme.headlineStyle.copyWith(fontSize: 24),
    headlineSmall: DVTextTheme.headlineStyle.copyWith(fontSize: 20),
    ///////////////////////////////////////////////////////////////////////
    titleLarge: DVTextTheme.titleStyle.copyWith(fontSize: 22),
    titleMedium: DVTextTheme.titleStyle.copyWith(fontSize: 18),
    titleSmall: DVTextTheme.titleStyle.copyWith(fontSize: 16),
    ///////////////////////////////////////////////////////////////////////
    bodyLarge: DVTextTheme.bodyStyle.copyWith(fontSize: 18),
    bodyMedium: DVTextTheme.bodyStyle.copyWith(fontSize: 16),
    bodySmall: DVTextTheme.bodyStyle.copyWith(fontSize: 14),
    ///////////////////////////////////////////////////////////////////////
    labelLarge: DVTextTheme.labelStyle.copyWith(fontSize: 16),
    labelMedium: DVTextTheme.labelStyle.copyWith(fontSize: 14),
    labelSmall: DVTextTheme.labelStyle.copyWith(fontSize: 12),
  );
}
