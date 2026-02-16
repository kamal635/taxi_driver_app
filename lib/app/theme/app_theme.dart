import 'package:flutter/material.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/app/theme/app_fonts.dart';

final class AppTheme {
  static ThemeData light(Locale locale) {
    final scheme = ColorScheme.fromSeed(seedColor: AppColors.taxiYellow);

    final fonts = AppFonts.resolve(locale);

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.bgBase,
      fontFamily: fonts.primary,
      fontFamilyFallback: fonts.fallback,
    );
  }
}
