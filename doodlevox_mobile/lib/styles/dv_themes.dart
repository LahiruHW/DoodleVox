import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:doodlevox_mobile/styles/dv_colors.dart';
import 'package:doodlevox_mobile/styles/dv_text_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:doodlevox_mobile/styles/dv_button_style.dart';
import 'package:doodlevox_mobile/styles/dv_qr_scan_style.dart';
import 'package:doodlevox_mobile/styles/dv_snackbar_style.dart';
import 'package:doodlevox_mobile/styles/dv_record_screen_style.dart';
import 'package:doodlevox_mobile/styles/dv_effects_sheet_style.dart';
import 'package:doodlevox_mobile/styles/dv_library_screen_style.dart';

class DVTheme {
  DVTheme._();

  // Color constants (Midnight Sun) — defined in DVColors
  static const Color primaryColor = DVColors.primary;
  static const Color secondaryColor = DVColors.secondary;
  static const Color tertiaryColor = DVColors.tertiary;
  static const Color neutralColor = DVColors.neutral;

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
    scaffoldBackgroundColor: secondaryColor,
    colorScheme: lightColorScheme,
    fontFamily: 'Inter',
    splashColor: Colors.transparent,
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
    textTheme: DVTextTheme.globalTextTheme.apply(fontSizeFactor: 1.spMin),
    cupertinoOverrideTheme: const NoDefaultCupertinoThemeData(
      applyThemeToAll: true,
      brightness: Brightness.light,
      primaryColor: primaryColor,
      primaryContrastingColor: neutralColor,
      scaffoldBackgroundColor: secondaryColor,
    ),
    dialogTheme: DialogThemeData(
      elevation: 0,
      backgroundColor: Colors.white,
      actionsPadding: .symmetric(horizontal: 10.w, vertical: 5.h),
      shape: RoundedRectangleBorder(borderRadius: .all(.circular(10.r))),
      titleTextStyle: TextStyle(
        fontFamily: 'Inter',
        fontSize: 20.spMin,
        fontWeight: .w600,
        color: neutralColor,
      ),
      contentTextStyle: TextStyle(
        fontFamily: 'Inter',
        fontSize: 14.spMin,
        fontWeight: .w400,
        color: neutralColor,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: .all(.circular(15.r))),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: .all(.circular(15.r))),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: .all(.circular(15.r))),
      ),
    ),
    cardTheme: CardThemeData(
      shape: RoundedRectangleBorder(borderRadius: .all(.circular(15.r))),
    ),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: neutralColor,
      titleTextStyle: TextStyle(
        fontFamily: 'Inter',
        fontSize: 20.spMin,
        fontWeight: .w600,
        color: neutralColor,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      enableFeedback: false,
      backgroundColor: Colors.white,
      selectedItemColor: primaryColor,
      unselectedItemColor: tertiaryColor,
      showSelectedLabels: true,
      showUnselectedLabels: false,
      selectedLabelStyle: TextStyle(
        fontFamily: 'Inter',
        fontSize: 10.spMin,
        fontWeight: .normal,
        color: primaryColor,
      ),
      unselectedLabelStyle: TextStyle(
        fontFamily: 'Inter',
        fontSize: 10.spMin,
        fontWeight: .normal,
        color: tertiaryColor,
      ),
    ),
    extensions: {
      DVButtonStyle.light,
      DVQrScanStyle.light,
      DVRecordScreenStyle.light,
      DVSnackbarStyle.light,
      DVEffectsSheetStyle.light,
      DVLibraryScreenStyle.light,
    },
  );

  static ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: neutralColor,
    colorScheme: darkColorScheme,
    fontFamily: 'Inter',
    splashColor: Colors.transparent,
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
    textTheme: DVTextTheme.globalTextTheme,
    cupertinoOverrideTheme: const NoDefaultCupertinoThemeData(
      applyThemeToAll: true,
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      primaryContrastingColor: neutralColor,
      scaffoldBackgroundColor: neutralColor,
    ),
    dialogTheme: DialogThemeData(
      elevation: 0,
      backgroundColor: Color(0xFF1E1E1E),
      actionsPadding: .symmetric(horizontal: 10.w, vertical: 5.h),
      shape: RoundedRectangleBorder(borderRadius: .all(.circular(10.r))),
      titleTextStyle: TextStyle(
        fontFamily: 'Inter',
        fontSize: 20.spMin,
        fontWeight: .w600,
        color: secondaryColor,
      ),
      contentTextStyle: TextStyle(
        fontFamily: 'Inter',
        fontSize: 14.spMin,
        fontWeight: .w400,
        color: secondaryColor,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: .all(.circular(15.r))),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: .all(.circular(15.r))),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: .all(.circular(15.r))),
      ),
    ),
    cardTheme: CardThemeData(
      shape: RoundedRectangleBorder(borderRadius: .all(.circular(15.r))),
    ),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: neutralColor,
      foregroundColor: secondaryColor,
      titleTextStyle: TextStyle(
        fontFamily: 'Inter',
        fontSize: 20.spMin,
        fontWeight: .w600,
        color: secondaryColor,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      backgroundColor: neutralColor,
      selectedItemColor: primaryColor,
      unselectedItemColor: tertiaryColor,
      showSelectedLabels: true,
      showUnselectedLabels: false,
      selectedLabelStyle: TextStyle(
        fontFamily: 'Inter',
        fontSize: 10.spMin,
        fontWeight: .normal,
        color: primaryColor,
      ),
      unselectedLabelStyle: TextStyle(
        fontFamily: 'Inter',
        fontSize: 10.spMin,
        fontWeight: .normal,
        color: tertiaryColor,
      ),
    ),
    extensions: {
      DVButtonStyle.dark,
      DVQrScanStyle.dark,
      DVRecordScreenStyle.dark,
      DVSnackbarStyle.dark,
      DVEffectsSheetStyle.dark,
      DVLibraryScreenStyle.dark,
    },
  );
}
