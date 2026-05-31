import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/app/theme/app_theme_colors.dart';
import 'package:bawabat_al_saeq/app/theme/app_typography.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TripsCommissionResultBox extends StatelessWidget {
  const TripsCommissionResultBox({
    required this.currency,
    required this.selectedTripsCount,
    required this.selectedTripsTotalText,
    required this.commissionAmountText,
    super.key,
  });

  final String currency;
  final int selectedTripsCount;
  final String selectedTripsTotalText;
  final String commissionAmountText;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: context.colors.primary.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: context.colors.primary.withValues(alpha: 0.28),
        ),
      ),
      child: Column(
        children: [
          _TripsCommissionResultLine(
            label: l10n.tripsCommissionSelectedTripsLabel,
            value: l10n.tripsTotalTrips(selectedTripsCount),
          ),
          AppSpacing.h8,
          _TripsCommissionResultLine(
            label: l10n.tripsCommissionSelectedTotalLabel,
            value: '$currency $selectedTripsTotalText',
          ),
          Divider(
            height: 22.h,
            color: context.colors.border,
          ),
          _TripsCommissionResultLine(
            label: l10n.tripsCommissionAmountDueLabel,
            value: '$currency $commissionAmountText',
            isEmphasized: true,
          ),
        ],
      ),
    );
  }
}

class _TripsCommissionResultLine extends StatelessWidget {
  const _TripsCommissionResultLine({
    required this.label,
    required this.value,
    this.isEmphasized = false,
  });

  final String label;
  final String value;
  final bool isEmphasized;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.subtitleSm.copyWith(
              color: context.colors.iconMuted,
            ),
          ),
        ),
        AppSpacing.w10,
        Flexible(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
            style:
                (isEmphasized ? AppTypography.titleSm : AppTypography.labelMd)
                    .copyWith(
                      color: context.colors.textPrimary,
                      fontWeight: FontWeight.w900,
                    ),
          ),
        ),
      ],
    );
  }
}
