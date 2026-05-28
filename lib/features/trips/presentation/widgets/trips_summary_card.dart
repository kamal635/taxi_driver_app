import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/app/theme/app_theme_colors.dart';
import 'package:bawabat_al_saeq/app/theme/app_typography.dart';
import 'package:bawabat_al_saeq/features/trips/presentation/widgets/trips_card_surface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TripsSummaryCard extends StatelessWidget {
  const TripsSummaryCard({
    required this.title,
    required this.tripsCountLabel,
    required this.tripsCountText,
    required this.earningsLabel,
    required this.earningsText,
    required this.averageFareLabel,
    required this.averageFareText,
    super.key,
  });

  final String title;
  final String tripsCountLabel;
  final String tripsCountText;
  final String earningsLabel;
  final String earningsText;
  final String averageFareLabel;
  final String averageFareText;

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
          LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth = constraints.maxWidth >= 340.w
                  ? (constraints.maxWidth - 10.w) / 2
                  : constraints.maxWidth;

              return Wrap(
                spacing: 10.w,
                runSpacing: 10.h,
                children: [
                  SizedBox(
                    width: itemWidth,
                    child: _TripsSummaryStat(
                      icon: Icons.local_taxi_rounded,
                      label: tripsCountLabel,
                      value: tripsCountText,
                    ),
                  ),
                  SizedBox(
                    width: itemWidth,
                    child: _TripsSummaryStat(
                      icon: Icons.payments_rounded,
                      label: earningsLabel,
                      value: earningsText,
                      valueColor: context.colors.success,
                    ),
                  ),
                  SizedBox(
                    width: itemWidth,
                    child: _TripsSummaryStat(
                      icon: Icons.query_stats_rounded,
                      label: averageFareLabel,
                      value: averageFareText,
                    ),
                  ),
                ],
              );
            },
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
        color: context.colors.surfaceMuted,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: context.colors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 38.r,
            height: 38.r,
            decoration: BoxDecoration(
              color: context.colors.primary.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: context.colors.border),
            ),
            child: Icon(
              icon,
              size: 20.r,
              color: context.colors.textPrimary,
            ),
          ),
          AppSpacing.w12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.subtitleSm,
                ),
                AppSpacing.h4,
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.labelMd.copyWith(
                    fontWeight: FontWeight.w900,
                    color: valueColor ?? context.colors.textPrimary,
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
