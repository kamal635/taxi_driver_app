import 'dart:async' show unawaited;

import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/app/theme/app_theme_colors.dart';
import 'package:bawabat_al_saeq/app/theme/app_typography.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/features/trips/presentation/widgets/commission/trips_commission_date_selector.dart';
import 'package:bawabat_al_saeq/features/trips/presentation/widgets/commission/trips_commission_percentage_field.dart';
import 'package:bawabat_al_saeq/features/trips/presentation/widgets/commission/trips_commission_result_box.dart';
import 'package:bawabat_al_saeq/shared/presentation/widgets/surfaces/app_card_surface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TripsCommissionCalculatorCard extends StatelessWidget {
  const TripsCommissionCalculatorCard({
    required this.fromDate,
    required this.toDate,
    required this.percentageText,
    required this.currency,
    required this.selectedTripsCount,
    required this.selectedTripsTotalText,
    required this.commissionAmountText,
    required this.onFromDateChanged,
    required this.onToDateChanged,
    required this.onClearDates,
    required this.onPercentageChanged,
    super.key,
  });

  final DateTime? fromDate;
  final DateTime? toDate;
  final String percentageText;
  final String currency;
  final int selectedTripsCount;
  final String selectedTripsTotalText;
  final String commissionAmountText;
  final ValueChanged<DateTime?> onFromDateChanged;
  final ValueChanged<DateTime?> onToDateChanged;
  final VoidCallback onClearDates;
  final ValueChanged<String> onPercentageChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final hasDateRange = fromDate != null || toDate != null;

    return AppCardSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _TripsCommissionCalculatorHeader(),
          AppSpacing.h16,
          Row(
            children: [
              Expanded(
                child: TripsCommissionDateSelector(
                  label: l10n.tripsCommissionFromDateLabel,
                  value: _formatDate(context, fromDate),
                  onTap: () => unawaited(
                    _selectDate(
                      context: context,
                      initialDate: fromDate ?? toDate ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: toDate ?? DateTime.now(),
                      onChanged: onFromDateChanged,
                    ),
                  ),
                ),
              ),
              AppSpacing.w10,
              Expanded(
                child: TripsCommissionDateSelector(
                  label: l10n.tripsCommissionToDateLabel,
                  value: _formatDate(context, toDate),
                  onTap: () => unawaited(
                    _selectDate(
                      context: context,
                      initialDate: toDate ?? fromDate ?? DateTime.now(),
                      firstDate: fromDate ?? DateTime(2020),
                      lastDate: DateTime.now(),
                      onChanged: onToDateChanged,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (hasDateRange) ...[
            AppSpacing.h10,
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton.icon(
                onPressed: onClearDates,
                icon: Icon(Icons.close_rounded, size: 18.r),
                label: Text(l10n.tripsCommissionClearDatesAction),
                style: TextButton.styleFrom(
                  foregroundColor: context.colors.iconMuted,
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ),
          ],
          AppSpacing.h16,
          TripsCommissionPercentageField(
            value: percentageText,
            labelText: l10n.tripsCommissionPercentageLabel,
            hintText: l10n.tripsCommissionPercentageHint,
            onChanged: onPercentageChanged,
          ),
          AppSpacing.h16,
          TripsCommissionResultBox(
            currency: currency,
            selectedTripsCount: selectedTripsCount,
            selectedTripsTotalText: selectedTripsTotalText,
            commissionAmountText: commissionAmountText,
          ),
        ],
      ),
    );
  }

  String _formatDate(BuildContext context, DateTime? value) {
    if (value == null) return context.l10n.tripsCommissionDatePlaceholder;
    return MaterialLocalizations.of(context).formatCompactDate(value);
  }

  Future<void> _selectDate({
    required BuildContext context,
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
    required ValueChanged<DateTime?> onChanged,
  }) async {
    final safeInitialDate = initialDate.isBefore(firstDate)
        ? firstDate
        : initialDate.isAfter(lastDate)
        ? lastDate
        : initialDate;

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: safeInitialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (!context.mounted || selectedDate == null) return;
    onChanged(selectedDate);
  }
}

class _TripsCommissionCalculatorHeader extends StatelessWidget {
  const _TripsCommissionCalculatorHeader();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
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
                l10n.tripsCommissionTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.titleSm,
              ),
              AppSpacing.h4,
              Text(
                l10n.tripsCommissionSubtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.subtitleSm,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
