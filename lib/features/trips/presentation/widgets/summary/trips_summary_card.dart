import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/app/theme/app_theme_colors.dart';
import 'package:bawabat_al_saeq/app/theme/app_typography.dart';
import 'package:bawabat_al_saeq/shared/presentation/widgets/surfaces/app_card_surface.dart';
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
    return AppCardSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42.r,
                height: 42.r,
                decoration: BoxDecoration(
                  color: context.colors.primary.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(color: context.colors.border),
                ),
                child: Icon(
                  Icons.payments_rounded,
                  size: 22.r,
                  color: context.colors.textPrimary,
                ),
              ),
              AppSpacing.w12,
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.titleSm,
                ),
              ),
            ],
          ),
          AppSpacing.h14,
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: context.colors.success.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(18.r),
              border: Border.all(
                color: context.colors.success.withValues(alpha: 0.20),
              ),
            ),
            child: Column(
              children: [
                Text(
                  earningsLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: AppTypography.subtitleSm.copyWith(
                    color: context.colors.success,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                AppSpacing.h6,
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    earningsText,
                    textAlign: TextAlign.center,
                    style: AppTypography.titleLg.copyWith(
                      color: context.colors.success,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.h12,
          _SummaryInfoRow(
            label: tripsCountLabel,
            value: tripsCountText,
            icon: Icons.local_taxi_rounded,
          ),
          AppSpacing.h8,
          _SummaryInfoRow(
            label: averageFareLabel,
            value: averageFareText,
            icon: Icons.query_stats_rounded,
          ),
        ],
      ),
    );
  }
}

class _SummaryInfoRow extends StatelessWidget {
  const _SummaryInfoRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: context.colors.surfaceMuted,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: context.colors.border),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18.r,
            color: context.colors.iconMuted,
          ),
          AppSpacing.w10,
          Expanded(
            child: Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.subtitleSm,
            ),
          ),
          AppSpacing.w12,
          Flexible(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
              style: AppTypography.labelMd.copyWith(
                color: context.colors.textPrimary,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
