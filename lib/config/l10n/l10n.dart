import 'package:flutter/material.dart';

import 'generated/app_localizations.dart';

export 'generated/app_localizations.dart';

/// Iloha qo‘llab-quvvatlaydigan tillar — [AppLocalizations] bilan sinxron.
class L10n {
  L10n._();

  static List<Locale> get supportedLocales =>
      List<Locale>.from(AppLocalizations.supportedLocales);

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      AppLocalizations.localizationsDelegates;

  /// [AppOptions] / [SettingsDataSource] uchun standart locale kodlari.
  static const Locale uz = Locale('uz', 'UZ');
  static const Locale ru = Locale('ru', 'RU');
  static const Locale en = Locale('en', 'US');

  /// Profil API `code` → ilova [Locale].
  static Locale localeFromProfileLanguageCode(String code) {
    switch (code.toLowerCase()) {
      case 'ru':
        return ru;
      case 'en':
        return en;
      case 'uz':
      default:
        return uz;
    }
  }
}

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
