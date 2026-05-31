import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppSettingsStorage {
  AppSettingsStorage({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  static const _themeModeKey = 'app_theme_mode';
  static const _localeKey = 'app_locale';

  final FlutterSecureStorage _storage;

  Future<ThemeMode?> readThemeMode() async {
    final raw = await _storage.read(key: _themeModeKey);
    return switch (raw) {
      'dark' => ThemeMode.dark,
      'light' => ThemeMode.light,
      'system' => ThemeMode.system,
      _ => null,
    };
  }

  Future<void> writeThemeMode(ThemeMode value) {
    final raw = switch (value) {
      ThemeMode.dark => 'dark',
      ThemeMode.light => 'light',
      ThemeMode.system => 'system',
    };
    return _storage.write(key: _themeModeKey, value: raw);
  }

  Future<Locale?> readLocale() async {
    final raw = await _storage.read(key: _localeKey);
    final languageCode = raw?.trim().toLowerCase();

    return switch (languageCode) {
      'ar' => const Locale('ar'),
      'en' => const Locale('en'),
      _ => null,
    };
  }

  Future<void> writeLocale(Locale value) {
    return _storage.write(key: _localeKey, value: value.languageCode);
  }
}
