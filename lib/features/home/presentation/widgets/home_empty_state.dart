import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/app/theme/app_typography.dart';

class HomeEmptyState extends StatelessWidget {
  const HomeEmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
    super.key,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        /// Icon
        Container(
          width: 160.r,
          height: 160.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary.withValues(alpha: 0.12),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.35),
              width: 1.2,
            ),
          ),

          child: Icon(
            icon,
            size: 40.r,
            color: AppColors.textPrimary.withValues(alpha: 0.85),
          ),
        ),
        AppSpacing.h18,

        /// Title
        Text(
          title,
          textAlign: TextAlign.center,
          style: AppTypography.titleSm,
        ),
        AppSpacing.h10,

        /// Subtitle
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 22.w),
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: AppTypography.bodyMuted,
          ),
        ),
      ],
    );
  }
}
