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
    this.accentColor,
    this.iconBackgroundColor,
    this.subtitleColor,
    this.trailing,
    super.key,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isDestructive;
  final Color? accentColor;
  final Color? iconBackgroundColor;
  final Color? subtitleColor;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final resolvedAccentColor =
        accentColor ??
        (isDestructive ? AppColors.error : AppColors.textPrimary);
    final resolvedIconBackgroundColor =
        iconBackgroundColor ??
        (isDestructive ? AppColors.errorBg : AppColors.bgWarm);
    final resolvedSubtitleColor =
        subtitleColor ??
        (isDestructive ? AppColors.error : AppColors.textSecondary);

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
                color: resolvedIconBackgroundColor,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: AppColors.border),
              ),
              child: Icon(
                icon,
                size: 22.r,
                color: resolvedAccentColor,
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
                      color: resolvedAccentColor,
                    ),
                  ),
                  AppSpacing.h6,
                  Text(
                    subtitle,
                    style: AppTypography.subtitleSm.copyWith(
                      color: resolvedSubtitleColor,
                    ),
                  ),
                ],
              ),
            ),
            trailing ??
                Icon(
                  AppIcons.arrowForward,
                  size: 14.r,
                  color: AppColors.iconMuted,
                ),
          ],
        ),
      ),
    );
  }
}
