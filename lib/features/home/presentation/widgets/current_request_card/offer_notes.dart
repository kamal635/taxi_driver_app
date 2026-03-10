import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/app/theme/app_typography.dart';
import 'package:taxi_driver_app/core/constants/app_icons.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';

class OfferNotes extends StatelessWidget {
  const OfferNotes({super.key, this.notes});

  final String? notes;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      padding: EdgeInsets.all(16.r),
      margin: EdgeInsets.only(top: 10.r),
      decoration: BoxDecoration(
        color: AppColors.errorBg,
        boxShadow: const [
          BoxShadow(
            color: AppColors.errorBg,
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
        border: BoxBorder.fromLTRB(
          left: const BorderSide(color: AppColors.error),
          bottom: const BorderSide(color: AppColors.error),
          right: const BorderSide(color: AppColors.error),
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12.r),
          bottomRight: Radius.circular(12.r),
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
                Text(
                  notes ?? '',
                  style: AppTypography.bodyMd,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
