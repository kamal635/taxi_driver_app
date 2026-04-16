import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/app/theme/app_typography.dart';

/// Small reusable header used by update surfaces and dialogs.
class AppUpdateCardHeader extends StatelessWidget {
  const AppUpdateCardHeader({
    required this.icon,
    required this.iconColor,
    required this.iconBackgroundColor,
    required this.title,
    super.key,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42.r,
          height: 42.r,
          decoration: BoxDecoration(
            color: iconBackgroundColor,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: AppColors.border),
          ),
          child: Icon(icon, color: iconColor, size: 22.r),
        ),
        AppSpacing.w12,
        Expanded(
          child: Text(
            title,
            style: AppTypography.titleSm,
          ),
        ),
      ],
    );
  }
}
