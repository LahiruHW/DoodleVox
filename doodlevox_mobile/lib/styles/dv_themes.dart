import 'package:flutter/material.dart';

class DVTheme {
  DVTheme._();

  // add color constants here

  static ColorScheme lightColorScheme = ColorScheme.fromSwatch();

  static ColorScheme darkColorScheme = ColorScheme.fromSwatch();

  static ThemeData lightTheme = ThemeData(
    colorScheme: lightColorScheme,
    textTheme: DVTextTheme.globalTextTheme,
    // add other theme properties here
  );

  static ThemeData darkTheme = ThemeData(
    colorScheme: darkColorScheme,
    textTheme: DVTextTheme.globalTextTheme,
    // add other theme properties here
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

