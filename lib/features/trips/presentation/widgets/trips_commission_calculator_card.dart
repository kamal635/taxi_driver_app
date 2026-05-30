import 'dart:async' show unawaited;

import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/app/theme/app_theme_colors.dart';
import 'package:bawabat_al_saeq/app/theme/app_typography.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/features/trips/presentation/widgets/trips_card_surface.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TripsCommissionCalculatorEntryCard extends StatelessWidget {
  const TripsCommissionCalculatorEntryCard({
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
        child: TripsCardSurface(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
              ),
              AppSpacing.h14,
              if (dateRangeText != null) ...[
                _EntryInfoRow(
                  label: dateRangeText!,
                  icon: Icons.calendar_month_rounded,
                  maxLines: 2,
                ),
                AppSpacing.h8,
              ],
              _EntryInfoRow(
                label: selectedTripsText,
                icon: Icons.local_taxi_rounded,
              ),
              AppSpacing.h8,
              _EntryInfoRow(
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

class _EntryInfoRow extends StatelessWidget {
  const _EntryInfoRow({
    required this.label,
    required this.icon,
    this.isHighlighted = false,
    this.maxLines = 1,
  });

  final String label;
  final IconData icon;
  final bool isHighlighted;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final foregroundColor = isHighlighted
        ? context.colors.success
        : context.colors.textPrimary;

    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.only(
        start: 10.w,
        end: 12.w,
        top: 9.h,
        bottom: 9.h,
      ),
      decoration: BoxDecoration(
        color: isHighlighted
            ? context.colors.success.withValues(alpha: 0.12)
            : context.colors.surfaceMuted,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isHighlighted
              ? context.colors.success.withValues(alpha: 0.24)
              : context.colors.border,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 17.r,
            color: isHighlighted
                ? context.colors.success
                : context.colors.iconMuted,
          ),
          AppSpacing.w8,
          Expanded(
            child: Text(
              label,
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.labelMd.copyWith(
                color: foregroundColor,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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

    return TripsCardSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
          ),
          AppSpacing.h16,
          Row(
            children: [
              Expanded(
                child: _DateSelector(
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
                child: _DateSelector(
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
          TextField(
            controller: TextEditingController(text: percentageText)
              ..selection = TextSelection.collapsed(
                offset: percentageText.length,
              ),
            onChanged: onPercentageChanged,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
            textInputAction: TextInputAction.done,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
            ],
            style: AppTypography.labelMd.copyWith(
              color: context.colors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
            decoration: InputDecoration(
              labelText: l10n.tripsCommissionPercentageLabel,
              hintText: l10n.tripsCommissionPercentageHint,
              suffixText: '%',
              filled: true,
              fillColor: context.colors.surfaceMuted,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: BorderSide(color: context.colors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: BorderSide(color: context.colors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: BorderSide(
                  color: context.colors.primary,
                  width: 1.4,
                ),
              ),
            ),
          ),
          AppSpacing.h16,
          _CommissionResultBox(
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

    if (!context.mounted) return;
    if (selectedDate == null) return;

    onChanged(selectedDate);
  }
}

class _DateSelector extends StatelessWidget {
  const _DateSelector({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: context.colors.surfaceMuted,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: context.colors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.subtitleSm,
              ),
              AppSpacing.h6,
              Row(
                children: [
                  Expanded(
                    child: Text(
                      value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.labelSm.copyWith(
                        color: context.colors.textPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.calendar_month_rounded,
                    size: 18.r,
                    color: context.colors.iconMuted,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CommissionResultBox extends StatelessWidget {
  const _CommissionResultBox({
    required this.currency,
    required this.selectedTripsCount,
    required this.selectedTripsTotalText,
    required this.commissionAmountText,
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
          _ResultLine(
            label: l10n.tripsCommissionSelectedTripsLabel,
            value: l10n.tripsTotalTrips(selectedTripsCount),
          ),
          AppSpacing.h8,
          _ResultLine(
            label: l10n.tripsCommissionSelectedTotalLabel,
            value: '$currency $selectedTripsTotalText',
          ),
          Divider(
            height: 22.h,
            color: context.colors.border,
          ),
          _ResultLine(
            label: l10n.tripsCommissionAmountDueLabel,
            value: '$currency $commissionAmountText',
            isEmphasized: true,
          ),
        ],
      ),
    );
  }
}

class _ResultLine extends StatelessWidget {
  const _ResultLine({
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
