import 'package:flutter/material.dart';

class DVTheme {
  DVTheme._();

  // Color constants (Midnight Sun)
  static const Color primaryColor = Color(0xFFFFB800); // gold
  static const Color secondaryColor = Color(0xFFFFFFFF); // white
  static const Color tertiaryColor = Color(0xFF888888); // grey
  static const Color neutralColor = Color(0xFF000000); // black

  static ColorScheme lightColorScheme = .light(
    primary: primaryColor,
    onPrimary: neutralColor,
    secondary: secondaryColor,
    onSecondary: neutralColor,
    tertiary: tertiaryColor,
    surface: Colors.white,
    onSurface: neutralColor,
  );

  static ColorScheme darkColorScheme = .dark(
    primary: primaryColor,
    onPrimary: neutralColor,
    secondary: secondaryColor,
    onSecondary: neutralColor,
    tertiary: tertiaryColor,
    surface: neutralColor,
    onSurface: secondaryColor,
  );

  static ThemeData lightTheme = ThemeData(
    colorScheme: lightColorScheme,
    fontFamily: 'Inter',
    textTheme: DVTextTheme.globalTextTheme,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: .zero),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: .zero),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: .zero),
      ),
    ),
    cardTheme: CardThemeData(
      shape: RoundedRectangleBorder(borderRadius: .zero),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    colorScheme: darkColorScheme,
    fontFamily: 'Inter',
    textTheme: DVTextTheme.globalTextTheme,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: .zero),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: .zero),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: .zero),
      ),
    ),
    cardTheme: CardThemeData(
      shape: RoundedRectangleBorder(borderRadius: .zero),
    ),
    scaffoldBackgroundColor: neutralColor,
  );
}

// /////////////////////////////////////////////////////////////////////////////
// /////////////////////////////////////////////////////////////////////////////

class DVTextTheme {
  DVTextTheme._();

  // add TextStyle static constants here

  static TextTheme globalTextTheme = TextTheme(
    // add TextStyle properties here
  );
}
