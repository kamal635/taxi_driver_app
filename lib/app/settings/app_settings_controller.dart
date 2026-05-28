import 'dart:async' show unawaited;

import 'package:bawabat_al_saeq/app/settings/app_settings_state.dart';
import 'package:bawabat_al_saeq/app/settings/app_settings_storage.dart';
import 'package:flutter/material.dart';

class AppSettingsController extends ChangeNotifier {
  AppSettingsController(this._storage) {
    unawaited(_load());
  }

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

  Future<void> toggleDarkMode() {
    return setThemeMode(_state.isDarkMode ? ThemeMode.light : ThemeMode.dark);
  }

  Future<void> setLocale(Locale value) async {
    if (_state.locale == value) return;

    _state = _state.copyWith(locale: value);
    notifyListeners();
    await _storage.writeLocale(value);
  }
}
