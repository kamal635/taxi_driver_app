import 'package:bawabat_al_saeq/app/theme/app_theme_colors.dart';
import 'package:bawabat_al_saeq/app/theme/app_typography.dart';
import 'package:bawabat_al_saeq/core/constants/app_icons.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Separate attention card for trip notes.
///
/// Used by both pending and accepted offers when the backend sends notes.
class OfferNotesCard extends StatelessWidget {
  const OfferNotesCard({
    required this.notes,
    super.key,
  });

  final String notes;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: colors.errorBg.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: colors.error.withValues(alpha: 0.38),
          width: 1.2.w,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.error.withValues(alpha: 0.08),
            blurRadius: 18.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52.r,
            height: 52.r,
            decoration: BoxDecoration(
              color: colors.error.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(18.r),
            ),
            child: Icon(
              AppIcons.note,
              color: colors.error,
              size: 26.r,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.tripNotes,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.titleSm.copyWith(
                    color: colors.error,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  notes,
                  style: AppTypography.bodyMd.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w800,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
