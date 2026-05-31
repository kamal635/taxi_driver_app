import 'dart:async' show unawaited;

import 'package:bawabat_al_saeq/app/settings/app_settings_state.dart';
import 'package:bawabat_al_saeq/app/settings/app_settings_storage.dart';
import 'package:flutter/material.dart';

class AppSettingsController extends ChangeNotifier {
  AppSettingsController(this._storage) {
    unawaited(_load());
  }

  static const Locale arabicLocale = Locale('ar');
  static const Locale englishLocale = Locale('en');

  final AppSettingsStorage _storage;

  AppSettingsState _state = const AppSettingsState.initial();

  AppSettingsState get state => _state;

  Future<void> _load() async {
    final themeMode = await _storage.readThemeMode();
    final locale = await _storage.readLocale();

    _state = _state.copyWith(
      themeMode: themeMode,
      locale: locale,
    );
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode value) async {
    if (_state.themeMode == value) return;

    _state = _state.copyWith(themeMode: value);
    notifyListeners();
    await _storage.writeThemeMode(value);
  }

  Future<void> useSystemTheme() {
    return setThemeMode(ThemeMode.system);
  }

  Future<void> useLightTheme() {
    return setThemeMode(ThemeMode.light);
  }

  Future<void> useDarkTheme() {
    return setThemeMode(ThemeMode.dark);
  }

  Future<void> toggleDarkMode() {
    return setThemeMode(_state.isDarkMode ? ThemeMode.light : ThemeMode.dark);
  }

  Future<void> setLocale(Locale value) async {
    final normalizedLocale = _normalizeLocale(value);
    if (_state.locale == normalizedLocale) return;

    _state = _state.copyWith(locale: normalizedLocale);
    notifyListeners();
    await _storage.writeLocale(normalizedLocale);
  }

  Future<void> setArabicLocale() {
    return setLocale(arabicLocale);
  }

  Future<void> setEnglishLocale() {
    return setLocale(englishLocale);
  }

  Future<void> toggleLocale() {
    return setLocale(_state.isArabic ? englishLocale : arabicLocale);
  }

  Locale _normalizeLocale(Locale value) {
    return switch (value.languageCode) {
      'en' => englishLocale,
      _ => arabicLocale,
    };
  }
}
