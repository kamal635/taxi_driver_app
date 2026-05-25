import 'package:bawabat_al_saeq/app/theme/app_colors.dart';
import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/app/theme/app_typography.dart';
import 'package:bawabat_al_saeq/features/trips/presentation/widgets/trips_card_surface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    return TripsCardSurface(
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
            valueColor: AppColors.success,
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
