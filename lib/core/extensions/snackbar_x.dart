import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    final messenger = ScaffoldMessenger.of(this)..hideCurrentSnackBar();
    final style = _snackStyleFor(type);

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
                style: AppTypography.labelSm.copyWith(color: AppColors.white),
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
) {
  return switch (type) {
    AppSnackType.success => (
      backgroundColor: AppColors.success,
      foregroundColor: AppColors.successBg,
      icon: AppIcons.success,
    ),
    AppSnackType.error => (
      backgroundColor: AppColors.error,
      foregroundColor: AppColors.errorBg,
      icon: AppIcons.error,
    ),
    AppSnackType.warning => (
      backgroundColor: AppColors.warning,
      foregroundColor: AppColors.warningBg,
      icon: AppIcons.warning,
    ),
    AppSnackType.info => (
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.infoBg,
      icon: AppIcons.info,
    ),
  };
}
