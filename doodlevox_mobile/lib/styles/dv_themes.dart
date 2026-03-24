import 'package:flutter/material.dart';
import 'package:doodlevox_mobile/styles/dv_button_style.dart';
import 'package:doodlevox_mobile/styles/dv_qr_scan_style.dart';
import 'package:doodlevox_mobile/styles/dv_snackbar_style.dart';
import 'package:doodlevox_mobile/styles/dv_record_screen_style.dart';

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
    splashColor: Colors.transparent,
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
    textTheme: DVTextTheme.globalTextTheme,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(borderRadius: .zero),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: const RoundedRectangleBorder(borderRadius: .zero),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        shape: const RoundedRectangleBorder(borderRadius: .zero),
      ),
    ),
    cardTheme: const CardThemeData(
      shape: RoundedRectangleBorder(borderRadius: .zero),
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: neutralColor,
      titleTextStyle: TextStyle(
        fontFamily: 'Inter',
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: neutralColor,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      enableFeedback: false,
      backgroundColor: Colors.white,
      selectedItemColor: primaryColor,
      unselectedItemColor: tertiaryColor,
      selectedLabelStyle: TextStyle(
        fontFamily: 'Inter',
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),
      unselectedLabelStyle: TextStyle(
        fontFamily: 'Inter',
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: tertiaryColor,
      ),
    ),
    extensions: {
      DVButtonStyle.light,
      DVQrScanStyle.light,
      DVRecordScreenStyle.light,
      DVSnackbarStyle.light,
    },
  );

  static ThemeData darkTheme = ThemeData(
    colorScheme: darkColorScheme,
    fontFamily: 'Inter',
    splashColor: Colors.transparent,
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
    textTheme: DVTextTheme.globalTextTheme,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(borderRadius: .zero),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: const RoundedRectangleBorder(borderRadius: .zero),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        shape: const RoundedRectangleBorder(borderRadius: .zero),
      ),
    ),
    cardTheme: const CardThemeData(
      shape: RoundedRectangleBorder(borderRadius: .zero),
    ),
    scaffoldBackgroundColor: neutralColor,
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: neutralColor,
      foregroundColor: secondaryColor,
      titleTextStyle: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: secondaryColor,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      backgroundColor: neutralColor,
      selectedItemColor: primaryColor,
      unselectedItemColor: tertiaryColor,
      selectedLabelStyle: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),
      unselectedLabelStyle: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: tertiaryColor,
      ),
    ),
    extensions: {
      DVButtonStyle.dark,
      DVQrScanStyle.dark,
      DVRecordScreenStyle.dark,
      DVSnackbarStyle.dark,
    },
  );
}

// /////////////////////////////////////////////////////////////////////////////
// /////////////////////////////////////////////////////////////////////////////

class DVTextTheme {
  DVTextTheme._();

  // add TextStyle static constants here

  static TextTheme globalTextTheme = const TextTheme(
    // add TextStyle properties here
  );
}
