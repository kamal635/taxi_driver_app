import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/app/theme/app_theme_colors.dart';
import 'package:bawabat_al_saeq/app/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum LocationStatusRowState {
  ready,
  info,
  warning,
}

class LocationStatusRow extends StatelessWidget {
  const LocationStatusRow({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.state,
    super.key,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final LocationStatusRowState state;

  @override
  Widget build(BuildContext context) {
    final accentColor = switch (state) {
      LocationStatusRowState.ready => context.colors.success,
      LocationStatusRowState.info => context.colors.info,
      LocationStatusRowState.warning => context.colors.error,
    };

    final backgroundColor = switch (state) {
      LocationStatusRowState.ready => context.colors.successBg,
      LocationStatusRowState.info => context.colors.infoBg,
      LocationStatusRowState.warning => context.colors.errorBg,
    };

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      child: Row(
        children: [
          Container(
            width: 42.r,
            height: 42.r,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: context.colors.border),
            ),
            child: Icon(icon, size: 22.r, color: accentColor),
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
                    color: context.colors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                AppSpacing.h6,
                Text(
                  subtitle,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.subtitleSm.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            switch (state) {
              LocationStatusRowState.ready => Icons.check_circle_rounded,
              LocationStatusRowState.info => Icons.info_rounded,
              LocationStatusRowState.warning => Icons.error_rounded,
            },
            size: 22.r,
            color: accentColor,
          ),
        ],
      ),
    );
  }
}
