import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/app/theme/app_theme_colors.dart';
import 'package:bawabat_al_saeq/app/theme/app_typography.dart';
import 'package:bawabat_al_saeq/core/constants/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A tappable profile action row.
class ProfileSectionItem extends StatelessWidget {
  const ProfileSectionItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.onPressed,
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
  final VoidCallback? onPressed;
  final bool isDestructive;
  final Color? accentColor;
  final Color? iconBackgroundColor;
  final Color? subtitleColor;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null;
    final resolvedAccentColor =
        accentColor ??
        (isDestructive ? context.colors.error : context.colors.textPrimary);
    final resolvedIconBackgroundColor =
        iconBackgroundColor ??
        (isDestructive
            ? context.colors.errorBg
            : context.colors.backgroundDecorative);
    final resolvedSubtitleColor =
        subtitleColor ??
        (isDestructive ? context.colors.error : context.colors.textSecondary);

    return Opacity(
      opacity: isEnabled ? 1 : 0.58,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18.r),
          onTap: onPressed,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            child: Row(
              children: [
                Container(
                  width: 42.r,
                  height: 42.r,
                  decoration: BoxDecoration(
                    color: resolvedIconBackgroundColor,
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(color: context.colors.border),
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
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.labelMd.copyWith(
                          fontWeight: FontWeight.w900,
                          color: resolvedAccentColor,
                        ),
                      ),
                      AppSpacing.h6,
                      Text(
                        subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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
                      color: context.colors.iconMuted,
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
