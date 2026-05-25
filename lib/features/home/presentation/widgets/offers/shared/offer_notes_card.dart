import 'package:bawabat_al_saeq/app/theme/app_colors.dart';
import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
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

    return Container(
      padding: EdgeInsets.all(16.r),
      margin: EdgeInsets.only(top: 10.r),
      decoration: const BoxDecoration(
        color: AppColors.errorBg,
        boxShadow: [
          BoxShadow(
            color: AppColors.errorBg,
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
        border: Border(
          left: BorderSide(color: AppColors.error),
          right: BorderSide(color: AppColors.error),
          bottom: BorderSide(color: AppColors.error),
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            AppIcons.note,
            color: AppColors.error,
          ),
          AppSpacing.w12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.tripNotes,
                  style: AppTypography.titleSm.copyWith(
                    color: AppColors.error,
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
