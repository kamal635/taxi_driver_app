import 'package:flutter/material.dart';

class AppSettingsState {
  const AppSettingsState({
    required this.locale,
    required this.themeMode,
  });

  const AppSettingsState.initial()
    : locale = const Locale('ar'),
      themeMode = ThemeMode.light;

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
}
