import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/app/theme/app_typography.dart';
import 'package:taxi_driver_app/core/constants/app_icons.dart';

/// A tappable profile action row.
class ProfileSectionItem extends StatelessWidget {
  const ProfileSectionItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onPressed,
    this.isDestructive = false,
    super.key,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final accentColor = isDestructive ? AppColors.error : AppColors.textPrimary;
    final iconBackgroundColor =
        isDestructive ? AppColors.errorBg : AppColors.bgWarm;
    final subtitleColor =
        isDestructive ? AppColors.error : AppColors.textSecondary;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      child: InkWell(
        onTap: onPressed,
        child: Row(
          children: [
            Container(
              width: 42.r,
              height: 42.r,
              decoration: BoxDecoration(
                color: iconBackgroundColor,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: AppColors.border),
              ),
              child: Icon(
                icon,
                size: 22.r,
                color: accentColor,
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
                      color: accentColor,
                    ),
                  ),
                  AppSpacing.h6,
                  Text(
                    subtitle,
                    style: AppTypography.subtitleSm.copyWith(
                      color: subtitleColor,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              AppIcons.arrowf,
              size: 14.r,
              color: AppColors.iconMuted,
            ),
          ],
        ),
      ),
    );
  }
}
