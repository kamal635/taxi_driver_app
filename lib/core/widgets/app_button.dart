import 'package:bawabat_al_saeq/app/theme/app_colors.dart';
import 'package:bawabat_al_saeq/app/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Shared primary action button.
///
/// The API stays intentionally small so feature widgets can reuse the same
/// button without rebuilding local variants every time.
class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.isLoading = false,
    this.backgroundColor,
    this.borderColor,
    this.labelColor,
    this.height = 44,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? labelColor;
  final double height;

  @override
  Widget build(BuildContext context) {
    final effectiveLabelColor = labelColor ?? AppColors.textPrimary;

    return SizedBox(
      width: double.infinity,
      height: height.h,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primary,
          foregroundColor: effectiveLabelColor,
          disabledBackgroundColor: (backgroundColor ?? AppColors.primary)
              .withValues(alpha: 0.55),
          disabledForegroundColor: effectiveLabelColor.withValues(alpha: 0.70),
          elevation: 0,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
            side: BorderSide(
              color: borderColor ?? Colors.transparent,
            ),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 18.w,
                height: 18.w,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: effectiveLabelColor,
                ),
              )
            : Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.button.copyWith(
                  color: effectiveLabelColor,
                ),
              ),
      ),
    );
  }
}
