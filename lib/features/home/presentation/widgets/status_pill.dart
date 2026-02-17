import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/app/theme/app_typography.dart';

class StatusPill extends StatelessWidget {
  const StatusPill({
    required this.text,
    required this.isOnline,
    super.key,
  });

  final String text;
  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    final bg = isOnline ? AppColors.successBg : AppColors.errorBg;
    final dot = isOnline ? AppColors.success : AppColors.error;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: AppColors.border),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Colored Dot
          Container(
            width: 8.r,
            height: 8.r,
            decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
          ),

          AppSpacing.w8,

          /// Text
          Text(text, style: AppTypography.labelSm),
        ],
      ),
    );
  }
}
