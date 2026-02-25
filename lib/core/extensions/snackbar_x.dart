import 'package:flutter/material.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/app/theme/app_typography.dart';
import 'package:taxi_driver_app/core/constants/app_icons.dart';

enum AppSnackType { success, error, warning, info }

extension SnackBarX on BuildContext {
  void showAppSnack(
    String message, {
    AppSnackType type = AppSnackType.info,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 3),
  }) {
    final messenger = ScaffoldMessenger.of(this)
      // Avoid stacking multiple snackbars
      ..hideCurrentSnackBar();

    final style = _styleFor(type);

    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        elevation: 0,
        duration: duration,
        backgroundColor: style.bg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        content: Row(
          children: [
            Icon(style.icon, color: style.fg),
            AppSpacing.w12,
            Expanded(
              child: Text(
                message,
                style: AppTypography.labelMd.copyWith(color: AppColors.white),
              ),
            ),
          ],
        ),
        action: (actionLabel != null && onAction != null)
            ? SnackBarAction(
                label: actionLabel,
                textColor: style.fg,
                onPressed: onAction,
              )
            : null,
      ),
    );
  }
}

({Color bg, Color fg, IconData icon}) _styleFor(AppSnackType type) {
  return switch (type) {
    AppSnackType.success => (
      bg: AppColors.success,
      fg: AppColors.successBg,
      icon: AppIcons.success,
    ),
    AppSnackType.error => (
      bg: AppColors.error,
      fg: AppColors.errorBg,
      icon: AppIcons.error,
    ),
    AppSnackType.warning => (
      bg: AppColors.warning,
      fg: AppColors.warningBg,
      icon: AppIcons.warning,
    ),
    AppSnackType.info => (
      bg: AppColors.taxiYellow,
      fg: AppColors.infoBg,
      icon: AppIcons.info,
    ),
  };
}
