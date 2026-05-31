import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/app/theme/app_theme_colors.dart';
import 'package:bawabat_al_saeq/app/theme/app_typography.dart';
import 'package:bawabat_al_saeq/features/trips/presentation/widgets/commission/trips_commission_info_row.dart';
import 'package:bawabat_al_saeq/shared/presentation/widgets/surfaces/app_card_surface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TripsCommissionEntryCard extends StatelessWidget {
  const TripsCommissionEntryCard({
    required this.title,
    required this.subtitle,
    required this.amountDueLabel,
    required this.amountDueText,
    required this.selectedTripsText,
    required this.onTap,
    this.dateRangeText,
    super.key,
  });

  final String title;
  final String subtitle;
  final String amountDueLabel;
  final String amountDueText;
  final String selectedTripsText;
  final VoidCallback onTap;
  final String? dateRangeText;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22.r),
        child: AppCardSurface(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TripsCommissionEntryHeader(title: title, subtitle: subtitle),
              AppSpacing.h14,
              if (dateRangeText != null) ...[
                TripsCommissionInfoRow(
                  label: dateRangeText!,
                  icon: Icons.calendar_month_rounded,
                  maxLines: 2,
                ),
                AppSpacing.h8,
              ],
              TripsCommissionInfoRow(
                label: selectedTripsText,
                icon: Icons.local_taxi_rounded,
              ),
              AppSpacing.h8,
              TripsCommissionInfoRow(
                label: '$amountDueLabel: $amountDueText',
                icon: Icons.payments_rounded,
                isHighlighted: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TripsCommissionEntryHeader extends StatelessWidget {
  const _TripsCommissionEntryHeader({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44.r,
          height: 44.r,
          decoration: BoxDecoration(
            color: context.colors.primary.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(15.r),
            border: Border.all(color: context.colors.border),
          ),
          child: Icon(
            Icons.percent_rounded,
            size: 22.r,
            color: context.colors.textPrimary,
          ),
        ),
        AppSpacing.w12,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.titleSm,
              ),
              AppSpacing.h4,
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.subtitleSm,
              ),
            ],
          ),
        ),
        AppSpacing.w8,
        Icon(
          Icons.tune_rounded,
          size: 22.r,
          color: context.colors.iconMuted,
        ),
      ],
    );
  }
}
