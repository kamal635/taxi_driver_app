import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/app/theme/app_theme_colors.dart';
import 'package:bawabat_al_saeq/app/theme/app_typography.dart';
import 'package:bawabat_al_saeq/core/widgets/app_button.dart';
import 'package:bawabat_al_saeq/core/widgets/app_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Shows a shared confirm dialog and returns `true` only when confirmed.
Future<bool> showAppConfirmDialog({
  required BuildContext context,
  required String title,
  required String message,
  required String confirmLabel,
  String? cancelLabel,
  IconData icon = Icons.help_outline_rounded,
  bool barrierDismissible = false,
  Color? iconColor,
  Color? backgroundColorIcon,
}) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (dialogContext) {
      return Dialog(
        backgroundColor: context.colors.surface,
        surfaceTintColor: Colors.transparent,
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
                  Container(
                    width: 40.r,
                    height: 40.r,
                    decoration: BoxDecoration(
                      color: backgroundColorIcon ?? context.colors.surfaceMuted,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: context.colors.border),
                    ),
                    child: Icon(
                      icon,
                      color: iconColor ?? context.colors.textPrimary,
                    ),
                  ),
                  AppSpacing.w12,
                  Expanded(
                    child: Text(
                      title,
                      style: AppTypography.titleSm,
                    ),
                  ),
                ],
              ),
              AppSpacing.h12,
              Text(
                message,
                style: AppTypography.bodyMuted,
              ),
              AppSpacing.h16,
              Row(
                children: [
                  if (cancelLabel != null) ...[
                    Expanded(
                      child: AppTextButton(
                        label: cancelLabel,
                        onPressed: () {
                          Navigator.of(dialogContext).pop(false);
                        },
                      ),
                    ),
                    AppSpacing.w8,
                  ],
                  Expanded(
                    child: AppButton(
                      label: confirmLabel,
                      onPressed: () {
                        Navigator.of(dialogContext).pop(true);
                      },
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
