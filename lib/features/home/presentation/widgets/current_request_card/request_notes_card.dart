import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/app/theme/app_typography.dart';
import 'package:taxi_driver_app/core/constants/app_icons.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';

class RequestNotesCard extends StatelessWidget {
  const RequestNotesCard({
    required this.notes,
    super.key,
  });

  final String? notes;

  @override
  Widget build(BuildContext context) {
    final text = notes?.trim() ?? '';
    final l10n = context.l10n;

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 10),
            color: Colors.black.withValues(alpha: 0.06),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28.r,
                height: 28.r,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  AppIcons.note,
                  size: 16.r,
                  color: AppColors.primary,
                ),
              ),
              AppSpacing.w10,
              Text(
                l10n.notes,
                style: AppTypography.titleSm,
              ),
            ],
          ),
          AppSpacing.h10,
          Container(height: 1, color: AppColors.border),
          AppSpacing.h10,
          Text(
            text,
            textAlign: TextAlign.start,
            style: AppTypography.subtitleMd.copyWith(
              color: AppColors.textSecondary,
              height: 1.4,
            ),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
          AppSpacing.h10,
        ],
      ),
    );
  }
}
