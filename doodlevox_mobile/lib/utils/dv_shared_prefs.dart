import 'package:shared_preferences/shared_preferences.dart';

class DVSharedPrefs {
  static late final SharedPreferences _prefs;

  static const String _themeModeKey = 'DV_THEME_MODE';
  static const String _languageKey = 'DV_LANGUAGE';

  static const String defaultThemeMode = 'dark';
  static const String defaultLanguage = 'en-US';

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Theme mode
  static String getThemeMode() {
    return _prefs.getString(_themeModeKey) ?? defaultThemeMode;
  }

  static Future<void> setThemeMode(String mode) async {
    await _prefs.setString(_themeModeKey, mode);
  }

  static bool isDarkMode() => getThemeMode() == 'dark';

  // Language
  static String getLanguage() {
    return _prefs.getString(_languageKey) ?? defaultLanguage;
  }

  static Future<void> setLanguage(String language) async {
    await _prefs.setString(_languageKey, language);
  }
}
