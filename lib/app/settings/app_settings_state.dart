import 'package:flutter/material.dart';

class AppSettingsState {
  const AppSettingsState({
    required this.locale,
    required this.themeMode,
  });

  const AppSettingsState.initial()
    : locale = const Locale('ar'),
      themeMode = ThemeMode.system;

  final Locale locale;
  final ThemeMode themeMode;

  AppSettingsState copyWith({
    Locale? locale,
    ThemeMode? themeMode,
  }) {
    return AppSettingsState(
      locale: locale ?? this.locale,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  bool get isDarkMode => themeMode == ThemeMode.dark;

  bool get isLightMode => themeMode == ThemeMode.light;

  bool get isSystemThemeMode => themeMode == ThemeMode.system;

  bool get isArabic => locale.languageCode == 'ar';

  bool get isEnglish => locale.languageCode == 'en';

  bool get isRtl => isArabic;
}
