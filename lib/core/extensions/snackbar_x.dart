import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/app/theme/app_theme_colors.dart';
import 'package:bawabat_al_saeq/app/theme/app_typography.dart';
import 'package:bawabat_al_saeq/core/constants/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Semantic snackbar variants used across the app.
enum AppSnackType { success, error, warning, info }

extension SnackBarX on BuildContext {
  /// Shows a consistently styled floating snackbar.
  void showAppSnack(
    String message, {
    AppSnackType type = AppSnackType.info,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 3),
  }) {
    if (message.trim().isEmpty) {
      return;
    }

    final messenger = ScaffoldMessenger.of(this)..hideCurrentSnackBar();

    final style = _snackStyleFor(type, colors);

    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16.r),
        elevation: 0,
        duration: duration,
        backgroundColor: style.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.r),
        ),
        content: Row(
          children: [
            Icon(
              style.icon,
              color: style.foregroundColor,
              size: 20.r,
            ),
            AppSpacing.w12,
            Expanded(
              child: Text(
                message,
                style: AppTypography.labelSm.copyWith(
                  color: style.foregroundColor,
                ),
              ),
            ),
          ],
        ),
        action: actionLabel != null && onAction != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: style.foregroundColor,
                onPressed: onAction,
              )
            : null,
      ),
    );
  }
}

({Color backgroundColor, Color foregroundColor, IconData icon}) _snackStyleFor(
  AppSnackType type,
  AppThemeColors colors,
) {
  return switch (type) {
    AppSnackType.success => (
      backgroundColor: colors.success,
      foregroundColor: colors.successBg,
      icon: AppIcons.success,
    ),
    AppSnackType.error => (
      backgroundColor: colors.error,
      foregroundColor: colors.errorBg,
      icon: AppIcons.error,
    ),
    AppSnackType.warning => (
      backgroundColor: colors.warning,
      foregroundColor: colors.warningBg,
      icon: AppIcons.warning,
    ),
    AppSnackType.info => (
      backgroundColor: colors.primary,
      foregroundColor: colors.textPrimary,
      icon: AppIcons.info,
    ),
  };
}
