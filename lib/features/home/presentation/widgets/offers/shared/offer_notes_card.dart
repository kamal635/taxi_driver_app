import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/app/theme/app_theme_colors.dart';
import 'package:bawabat_al_saeq/app/theme/app_typography.dart';
import 'package:bawabat_al_saeq/core/constants/app_icons.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Notes panel shown under an offer card when notes are available.
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
      padding: EdgeInsets.all(16.r),
      margin: EdgeInsets.only(top: 10.r),
      decoration: BoxDecoration(
        color: colors.errorBg,
        boxShadow: [
          BoxShadow(
            color: colors.errorBg.withValues(alpha: 0.55),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
        border: Border(
          left: BorderSide(color: colors.error),
          right: BorderSide(color: colors.error),
          bottom: BorderSide(color: colors.error),
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12.r),
          bottomRight: Radius.circular(12.r),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            AppIcons.note,
            color: colors.error,
          ),
          AppSpacing.w12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.tripNotes,
                  style: AppTypography.titleSm.copyWith(
                    color: colors.error,
                    fontSize: 16.sp,
                  ),
                ),
                AppSpacing.h6,
                Text(notes, style: AppTypography.bodyMd),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
