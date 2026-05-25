import 'package:bawabat_al_saeq/app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Centralized typography tokens.
final class AppTypography {
  AppTypography._();

  static TextStyle get titleLg => _style(
    fontSize: 26,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    height: 1.15,
  );

  static TextStyle get titleMd => _style(
    fontSize: 22,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    height: 1.20,
  );

  static TextStyle get titleSm => _style(
    fontSize: 18,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    height: 1.25,
  );

  static TextStyle get subtitleMd => _style(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.30,
  );

  static TextStyle get subtitleSm => _style(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.30,
  );

  static TextStyle get labelMd => _style(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.25,
  );

  static TextStyle get labelSm => _style(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.25,
  );

  static TextStyle get bodyMd => _style(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.35,
  );

  static TextStyle get bodySm => _style(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.35,
  );

  static TextStyle get bodyMuted => _style(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.35,
  );

  static TextStyle get button => _style(
    fontSize: 16,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    height: 1.20,
  );

  static TextStyle _style({
    required double fontSize,
    required FontWeight fontWeight,
    required Color color,
    required double height,
  }) {
    return TextStyle(
      fontSize: fontSize.sp,
      fontWeight: fontWeight,
      color: color,
      height: height,
    );
  }
}
