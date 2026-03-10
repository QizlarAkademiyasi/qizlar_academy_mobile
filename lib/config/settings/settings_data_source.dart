import 'dart:async';

import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

const String _keyThemeMode = 'theme_mode';
const String _keyLocaleLanguage = 'locale_language_code';
const String _keyLocaleCountry = 'locale_country_code';

/// Locale va ThemeMode ni saqlash va stream orqali reaktiv yangilash.
abstract class SettingsDataSource {
  Locale getLocale();
  Future<void> setLocale(Locale locale);
  Future<void> clearLocale();
  ThemeMode getThemeMode();
  Future<void> setThemeMode(ThemeMode themeMode);
  Stream<ThemeMode> get themeModeStream;
  Stream<Locale> get localeStream;
}

class SettingsDataSourceImpl implements SettingsDataSource {
  SettingsDataSourceImpl(this._prefs) {
    _themeModeController = StreamController<ThemeMode>.broadcast();
    _localeController = StreamController<Locale>.broadcast();
    _themeModeController.add(getThemeMode());
    _localeController.add(getLocale());
  }

  final SharedPreferences _prefs;
  late final StreamController<ThemeMode> _themeModeController;
  late final StreamController<Locale> _localeController;

  @override
  Locale getLocale() {
    final languageCode = _prefs.getString(_keyLocaleLanguage);
    final countryCode = _prefs.getString(_keyLocaleCountry);
    if (languageCode == null) {
      return const Locale('uz', 'UZ');
    }
    return Locale(languageCode, countryCode);
  }

  @override
  Future<void> setLocale(Locale locale) async {
    await _prefs.setString(_keyLocaleLanguage, locale.languageCode);
    await _prefs.setString(_keyLocaleCountry, locale.countryCode ?? '');
    _localeController.add(locale);
  }

  @override
  Future<void> clearLocale() async {
    await _prefs.remove(_keyLocaleLanguage);
    await _prefs.remove(_keyLocaleCountry);
    _localeController.add(const Locale('uz', 'UZ'));
  }

  @override
  ThemeMode getThemeMode() {
    final index = _prefs.getInt(_keyThemeMode);
    if (index == null) return ThemeMode.system;
    return ThemeMode.values[index.clamp(0, ThemeMode.values.length - 1)];
  }

  @override
  Future<void> setThemeMode(ThemeMode themeMode) async {
    await _prefs.setInt(_keyThemeMode, themeMode.index);
    _themeModeController.add(themeMode);
  }

  @override
  Stream<ThemeMode> get themeModeStream => _themeModeController.stream;

  @override
  Stream<Locale> get localeStream => _localeController.stream;
}
