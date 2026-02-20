import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/app/theme/app_typography.dart';
import 'package:taxi_driver_app/core/constants/app_icons.dart';

class ProfileSectionItem extends StatelessWidget {
  const ProfileSectionItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onPressed,
    this.isSignOut = false,
    super.key,
  });
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isSignOut;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      child: Row(
        children: [
          Container(
            width: 42.r,
            height: 42.r,
            decoration: BoxDecoration(
              color: isSignOut ? AppColors.errorBg : AppColors.bgWarm,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: AppColors.border),
            ),
            child: Icon(
              icon,
              size: 22.r,
              color: isSignOut ? AppColors.error : AppColors.textPrimary,
            ),
          ),
          AppSpacing.w12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.labelMd.copyWith(
                    fontWeight: FontWeight.w900,
                    color: isSignOut ? AppColors.error : AppColors.textPrimary,
                  ),
                ),
                AppSpacing.h6,
                Text(
                  subtitle,
                  style: AppTypography.subtitleSm.copyWith(
                    color: isSignOut
                        ? AppColors.error
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: onPressed,
            icon: Icon(
              AppIcons.arrowf,
              size: 14.r,
              color: AppColors.iconMuted,
            ),
          ),
        ],
      ),
    );
  }
}
