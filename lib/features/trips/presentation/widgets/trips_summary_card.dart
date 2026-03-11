import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/app/theme/app_typography.dart';

class TripsSummaryCard extends StatelessWidget {
  const TripsSummaryCard({
    required this.title,
    required this.earningsLabel,
    required this.earningsText,
    super.key,
  });

  final String title;
  final String earningsLabel;
  final String earningsText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 10),
            color: AppColors.textPrimary.withValues(alpha: 0.06),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.titleSm,
          ),
          AppSpacing.h12,

          _TripsSummaryStat(
            icon: Icons.payments_rounded,
            label: earningsLabel,
            value: earningsText,
            valueColor: const Color(0xFF16A34A),
          ),
        ],
      ),
    );
  }
}

class _TripsSummaryStat extends StatelessWidget {
  const _TripsSummaryStat({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.bgBase,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 38.r,
            height: 38.r,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.border),
            ),
            child: Icon(
              icon,
              size: 20.r,
              color: AppColors.textPrimary,
            ),
          ),
          AppSpacing.w12,
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTypography.subtitleSm,
                ),
                AppSpacing.h4,
                Text(
                  value,
                  style: AppTypography.labelMd.copyWith(
                    fontWeight: FontWeight.w900,
                    color: valueColor ?? AppColors.textPrimary,
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
