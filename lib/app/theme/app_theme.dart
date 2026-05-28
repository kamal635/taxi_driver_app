import 'package:bawabat_al_saeq/app/theme/app_colors.dart';
import 'package:bawabat_al_saeq/app/theme/app_fonts.dart';
import 'package:bawabat_al_saeq/app/theme/app_theme_colors.dart';
import 'package:flutter/material.dart';

/// Application theme factory.
final class AppTheme {
  AppTheme._();

  static ThemeData light(Locale locale) {
    return _build(
      locale: locale,
      brightness: Brightness.light,
      colors: AppThemeColors.light,
    );
  }

  static ThemeData dark(Locale locale) {
    return _build(
      locale: locale,
      brightness: Brightness.dark,
      colors: AppThemeColors.dark,
    );
  }

  static ThemeData _build({
    required Locale locale,
    required Brightness brightness,
    required AppThemeColors colors,
  }) {
    final fonts = AppFonts.resolve(locale);

    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: brightness,
      primary: colors.primary,
      surface: colors.surface,
      error: colors.error,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      extensions: <ThemeExtension<dynamic>>[colors],
      scaffoldBackgroundColor: colors.background,
      fontFamily: fonts.primary,
      fontFamilyFallback: fonts.fallback,
      splashFactory: NoSplash.splashFactory,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      dividerColor: colors.border,
      iconTheme: IconThemeData(color: colors.textPrimary),
      textTheme: ThemeData(brightness: brightness).textTheme.apply(
        bodyColor: colors.textPrimary,
        displayColor: colors.textPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        foregroundColor: colors.textPrimary,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.surface,
        surfaceTintColor: Colors.transparent,
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: const OutlineInputBorder(),
        fillColor: colors.surface,
        hintStyle: TextStyle(color: colors.textSecondary),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return colors.primary;
          return colors.iconMuted;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colors.primary.withValues(alpha: 0.35);
          }
          return colors.border;
        }),
      ),
    );
  }
}
