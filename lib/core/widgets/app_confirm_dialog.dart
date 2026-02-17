import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/app/theme/app_typography.dart';
import 'package:taxi_driver_app/core/widgets/app_button.dart';

Future<bool> showAppConfirmDialog({
  required BuildContext context,
  required String title,
  required String message,
  required String confirmLabel,
  required String cancelLabel,
  IconData icon = Icons.help_outline_rounded,
  bool barrierDismissible = false,
  Color? iconColor,
  Color? backgroundIconColor,
}) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (context) {
      return Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 18.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  /// Icon
                  Container(
                    width: 40.r,
                    height: 40.r,
                    decoration: BoxDecoration(
                      color: backgroundIconColor,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Icon(icon, color: iconColor),
                  ),

                  AppSpacing.w12,

                  /// Title
                  Expanded(child: Text(title, style: AppTypography.titleSm)),
                ],
              ),

              AppSpacing.h12,

              /// Message
              Text(message, style: AppTypography.bodyMuted),

              AppSpacing.h16,

              // Actions
              Row(
                children: [
                  /// Cancel
                  Expanded(
                    child: AppButton(
                      backgroundColor: Colors.transparent,
                      label: cancelLabel,
                      onPressed: () => context.pop(true),
                    ),
                  ),

                  AppSpacing.w12,

                  /// Confirm
                  Expanded(
                    child: AppButton(
                      label: confirmLabel,
                      onPressed: () => context.pop(true),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );

  return result ?? false;
}
