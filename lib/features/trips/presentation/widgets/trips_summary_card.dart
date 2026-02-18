import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/app/theme/app_typography.dart';

class TripsSummaryCard extends StatelessWidget {
  const TripsSummaryCard({
    required this.title,
    required this.subtitle,
    required this.tripsLabel,
    required this.earningsLabel,
    required this.tripsCountText,
    required this.earningsText,
    super.key,
  });

  final String title;
  final String subtitle;
  final String tripsLabel;
  final String earningsLabel;
  final String tripsCountText;
  final String earningsText;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Text(title, style: AppTypography.titleSm),
          AppSpacing.h6,
          Text(subtitle, style: AppTypography.subtitleMd),
          AppSpacing.h12,

          Row(
            children: [
              Expanded(
                child: _SummaryStat(
                  icon: Icons.check_circle_rounded,
                  label: tripsLabel,
                  value: tripsCountText,
                ),
              ),

              AppSpacing.w12,

              Expanded(
                child: _SummaryStat(
                  icon: Icons.payments_rounded,
                  label: earningsLabel,
                  value: earningsText,
                  valueColor: const Color(0xFF16A34A),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryStat extends StatelessWidget {
  const _SummaryStat({
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
        children: [
          Container(
            width: 38.r,
            height: 38.r,
            decoration: BoxDecoration(
              color: AppColors.taxiYellow.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.border),
            ),
            child: Icon(icon, size: 20.r, color: AppColors.textPrimary),
          ),

          AppSpacing.w12,

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTypography.subtitleSm),

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
