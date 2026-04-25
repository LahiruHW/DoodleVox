import 'package:shared_preferences/shared_preferences.dart';

class DVSharedPrefs {
  static late final SharedPreferences _prefs;

  static const String _themeModeKey = 'DV_THEME_MODE';
  static const String _languageKey = 'DV_LANGUAGE';
  static const String _encodingKey = 'DV_AUDIO_ENCODING';

  static const String defaultThemeMode = 'dark';
  static const String defaultLanguage = 'en-US';
  static const bool defaultIsFirstLaunch = true;
  static const String defaultEncoding = 'wav';

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

  // First launch flag
  static bool getIsFirstLaunch() {
    return _prefs.getBool('DV_IS_FIRST_LAUNCH') ?? defaultIsFirstLaunch;
  }

  static Future<void> setIsFirstLaunch(bool value) async {
    await _prefs.setBool('DV_IS_FIRST_LAUNCH', value);
  }

  // Audio encoding
  static String getEncoding() {
    return _prefs.getString(_encodingKey) ?? defaultEncoding;
  }

  static Future<void> setEncoding(String encoding) async {
    await _prefs.setString(_encodingKey, encoding);
  }
}
