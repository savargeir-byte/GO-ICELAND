import 'package:flutter/material.dart';

class L10n {
  static const List<Locale> supported = [
    Locale('en'), // English
    Locale('de'), // German
    Locale('fr'), // French
    Locale('es'), // Spanish
    Locale('zh'), // Chinese (Simplified)
    Locale('ja'), // Japanese
  ];

  static Locale? getLocale(String? code) {
    if (code == null) return null;

    for (var locale in supported) {
      if (locale.languageCode == code) return locale;
    }

    return null;
  }

  static String getLanguageName(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'de':
        return 'Deutsch';
      case 'fr':
        return 'Français';
      case 'es':
        return 'Español';
      case 'zh':
        return '中文';
      case 'ja':
        return '日本語';
      default:
        return code.toUpperCase();
    }
  }

  static String getLanguageFlag(String code) {
    switch (code) {
      case 'en':
        return '🇬🇧';
      case 'de':
        return '🇩🇪';
      case 'fr':
        return '🇫🇷';
      case 'es':
        return '🇪🇸';
      case 'zh':
        return '🇨🇳';
      case 'ja':
        return '🇯🇵';
      default:
        return '🌍';
    }
  }
}
