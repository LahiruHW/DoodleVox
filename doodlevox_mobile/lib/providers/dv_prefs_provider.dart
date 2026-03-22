import 'package:logging/logging.dart';
import 'package:flutter/material.dart';
import 'package:doodlevox_mobile/utils/dv_shared_prefs.dart';

class DVPrefsProvider extends ChangeNotifier {
  final _log = Logger('DVPrefsProvider');

  ThemeMode _themeMode = ThemeMode.dark;
  String _language = DVSharedPrefs.defaultLanguage;

  ThemeMode get themeMode => _themeMode;
  String get language => _language;

  DVPrefsProvider() {
    _loadFromPrefs();
  }

  void _loadFromPrefs() {
    final mode = DVSharedPrefs.getThemeMode();
    _themeMode = mode == 'light' ? ThemeMode.light : ThemeMode.dark;
    _language = DVSharedPrefs.getLanguage();
    _log.fine('Loaded prefs: theme=$mode, language=$_language');
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    final modeStr = mode == ThemeMode.light ? 'light' : 'dark';
    await DVSharedPrefs.setThemeMode(modeStr);
    _log.fine('Theme mode set to $modeStr');
    notifyListeners();
  }

  Future<void> toggleThemeMode() async {
    final newMode =
        _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await setThemeMode(newMode);
  }

  Future<void> setLanguage(String language) async {
    _language = language;
    await DVSharedPrefs.setLanguage(language);
    _log.fine('Language set to $language');
    notifyListeners();
  }
}
