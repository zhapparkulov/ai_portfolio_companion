import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleStorage {
  static const _key = 'app_locale';
  final SharedPreferences _prefs;

  const LocaleStorage(this._prefs);

  Locale getLocale() {
    final languageCode = _prefs.getString(_key);
    return languageCode != null ? Locale(languageCode) : const Locale('en');
  }

  Future<void> saveLocale(Locale locale) async {
    await _prefs.setString(_key, locale.languageCode);
  }
}
