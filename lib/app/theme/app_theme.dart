import 'package:flutter/material.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/app/theme/app_fonts.dart';

final class AppTheme {
  static ThemeData light({required bool isArabic}) {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.taxiYellow,
    );

    final primaryFont = isArabic ? AppFonts.arabic : AppFonts.english;
    final fallbackFont = isArabic ? AppFonts.english : AppFonts.arabic;

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.bgBase,
      fontFamily: primaryFont,
      fontFamilyFallback: <String>[fallbackFont],
    );
  }
}
