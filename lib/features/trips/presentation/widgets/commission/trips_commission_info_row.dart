import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/app/theme/app_theme_colors.dart';
import 'package:bawabat_al_saeq/app/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TripsCommissionInfoRow extends StatelessWidget {
  const TripsCommissionInfoRow({
    required this.label,
    required this.icon,
    this.isHighlighted = false,
    this.maxLines = 1,
    super.key,
  });

  final String label;
  final IconData icon;
  final bool isHighlighted;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final foregroundColor = isHighlighted
        ? context.colors.success
        : context.colors.textPrimary;

    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.only(
        start: 10.w,
        end: 12.w,
        top: 9.h,
        bottom: 9.h,
      ),
      decoration: BoxDecoration(
        color: isHighlighted
            ? context.colors.success.withValues(alpha: 0.12)
            : context.colors.surfaceMuted,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isHighlighted
              ? context.colors.success.withValues(alpha: 0.24)
              : context.colors.border,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 17.r,
            color: isHighlighted
                ? context.colors.success
                : context.colors.iconMuted,
          ),
          AppSpacing.w8,
          Expanded(
            child: Text(
              label,
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.labelMd.copyWith(
                color: foregroundColor,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
