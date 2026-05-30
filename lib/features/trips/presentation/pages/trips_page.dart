import 'dart:async' show unawaited;

import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/app/theme/app_theme_colors.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/features/trips/domain/entities/completed_offer_entity.dart';
import 'package:bawabat_al_saeq/features/trips/presentation/controllers/completed_offers_controller.dart';
import 'package:bawabat_al_saeq/features/trips/presentation/formatters/trip_amount_formatter.dart';
import 'package:bawabat_al_saeq/features/trips/presentation/listeners/trips_error_listener.dart';
import 'package:bawabat_al_saeq/features/trips/presentation/widgets/trips_commission_calculator_card.dart';
import 'package:bawabat_al_saeq/features/trips/presentation/widgets/trips_content_section.dart';
import 'package:bawabat_al_saeq/features/trips/presentation/widgets/trips_filter_dropdown.dart';
import 'package:bawabat_al_saeq/features/trips/presentation/widgets/trips_section_header.dart';
import 'package:bawabat_al_saeq/features/trips/presentation/widgets/trips_summary_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TripsPage extends ConsumerWidget {
  const TripsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripsState = ref.watch(completedOffersControllerProvider);
    final result = tripsState.result;
    final offers = result?.offers ?? const <CompletedOfferEntity>[];
    final tripsCount = result?.count ?? offers.length;
    final totalProfitsValue = _parsePriceValue(result?.totalProfits ?? '0');
    final totalProfitsText = formatTripAmount(totalProfitsValue);
    final averageFareValue = tripsCount == 0
        ? 0
        : totalProfitsValue / tripsCount;
    final averageFareText = formatTripAmount(averageFareValue);
    final currency = context.l10n.currencySyrianPound;
    final commissionOffers = _filterOffersByDateRange(
      offers: offers,
      fromDate: tripsState.commissionFromDate,
      toDate: tripsState.commissionToDate,
    );
    final commissionTotalValue = _calculateOffersTotal(commissionOffers);
    final commissionPercentage = _parsePercentage(
      tripsState.commissionPercentageText,
    );
    final commissionAmountValue =
        commissionTotalValue * (commissionPercentage / 100);
    final commissionDateRangeText = _formatCommissionDateRange(
      context: context,
      fromDate: tripsState.commissionFromDate,
      toDate: tripsState.commissionToDate,
    );

    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: () {
            return ref
                .read(completedOffersControllerProvider.notifier)
                .refresh();
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate.fixed([
                    TripsSummaryCard(
                      title: context.l10n.tripsSummaryTitle,
                      tripsCountLabel: context.l10n.tripsSummaryTripsLabel,
                      tripsCountText: tripsCount.toString(),
                      earningsLabel: context.l10n.tripsSummaryEarningsLabel,
                      earningsText: '$currency $totalProfitsText',
                      averageFareLabel:
                          context.l10n.tripsSummaryAverageFareLabel,
                      averageFareText: '$currency $averageFareText',
                    ),
                    AppSpacing.h12,
                    TripsCommissionCalculatorEntryCard(
                      title: context.l10n.tripsCommissionTitle,
                      subtitle: context.l10n.tripsCommissionSubtitle,
                      amountDueLabel:
                          context.l10n.tripsCommissionAmountDueLabel,
                      amountDueText:
                          '''$currency ${formatTripAmount(commissionAmountValue)}''',
                      selectedTripsText: context.l10n.tripsTotalTrips(
                        commissionOffers.length,
                      ),
                      dateRangeText: commissionDateRangeText,
                      onTap: () => _showCommissionCalculatorSheet(context),
                    ),
                    AppSpacing.h16,
                    TripsFilterDropdown(
                      value: tripsState.selectedPeriod,
                      enabled: tripsState.canChangePeriod,
                      onChanged: (value) async {
                        if (value == null) return;

                        await ref
                            .read(completedOffersControllerProvider.notifier)
                            .changePeriod(value);
                      },
                    ),
                    AppSpacing.h18,
                    TripsSectionHeader(
                      title: context.l10n.tripsRecentTitle,
                      subtitle: context.l10n.tripsTotalTrips(tripsCount),
                    ),
                    AppSpacing.h12,
                  ]),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                sliver: TripsContentSection(
                  offers: offers,
                  isInitialLoading: tripsState.isInitialLoading,
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 102.h)),
            ],
          ),
        ),
        if (tripsState.isRefreshing && !tripsState.isInitialLoading)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: LinearProgressIndicator(
              minHeight: 2,
              color: context.colors.primary,
              backgroundColor: context.colors.primary.withValues(alpha: 0.18),
            ),
          ),
        const TripsErrorListener(),
      ],
    );
  }
}

String? _formatCommissionDateRange({
  required BuildContext context,
  required DateTime? fromDate,
  required DateTime? toDate,
}) {
  if (fromDate == null && toDate == null) return null;

  final l10n = context.l10n;
  final localizations = MaterialLocalizations.of(context);

  if (fromDate != null && toDate != null) {
    return '${l10n.tripsCommissionFromDateLabel}: '
        '${localizations.formatCompactDate(fromDate)} • '
        '${l10n.tripsCommissionToDateLabel}: '
        '${localizations.formatCompactDate(toDate)}';
  }

  if (fromDate != null) {
    return '${l10n.tripsCommissionFromDateLabel}: '
        '${localizations.formatCompactDate(fromDate)}';
  }

  return '${l10n.tripsCommissionToDateLabel}: '
      '${localizations.formatCompactDate(toDate!)}';
}

void _showCommissionCalculatorSheet(BuildContext context) {
  unawaited(
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _TripsCommissionCalculatorSheet(),
    ),
  );
}

class _TripsCommissionCalculatorSheet extends ConsumerWidget {
  const _TripsCommissionCalculatorSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripsState = ref.watch(completedOffersControllerProvider);
    final tripsController = ref.read(
      completedOffersControllerProvider.notifier,
    );
    final offers = tripsState.result?.offers ?? const <CompletedOfferEntity>[];
    final commissionOffers = _filterOffersByDateRange(
      offers: offers,
      fromDate: tripsState.commissionFromDate,
      toDate: tripsState.commissionToDate,
    );
    final commissionTotalValue = _calculateOffersTotal(commissionOffers);
    final commissionPercentage = _parsePercentage(
      tripsState.commissionPercentageText,
    );
    final commissionAmountValue =
        commissionTotalValue * (commissionPercentage / 100);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.colors.background,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(28.r),
          ),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: context.colors.border,
                  borderRadius: BorderRadius.circular(999.r),
                ),
              ),
              AppSpacing.h14,
              TripsCommissionCalculatorCard(
                fromDate: tripsState.commissionFromDate,
                toDate: tripsState.commissionToDate,
                percentageText: tripsState.commissionPercentageText,
                currency: context.l10n.currencySyrianPound,
                selectedTripsCount: commissionOffers.length,
                selectedTripsTotalText: formatTripAmount(
                  commissionTotalValue,
                ),
                commissionAmountText: formatTripAmount(
                  commissionAmountValue,
                ),
                onFromDateChanged: tripsController.setCommissionFromDate,
                onToDateChanged: tripsController.setCommissionToDate,
                onClearDates: tripsController.clearCommissionDateRange,
                onPercentageChanged:
                    tripsController.setCommissionPercentageText,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

List<CompletedOfferEntity> _filterOffersByDateRange({
  required List<CompletedOfferEntity> offers,
  required DateTime? fromDate,
  required DateTime? toDate,
}) {
  if (fromDate == null && toDate == null) return offers;

  final normalizedFromDate = _dateOnly(fromDate);
  final normalizedToDate = _endOfDay(toDate);

  return offers
      .where((offer) {
        final tripDate = offer.updatedAt;
        final isAfterStart =
            normalizedFromDate == null ||
            !tripDate.isBefore(normalizedFromDate);
        final isBeforeEnd =
            normalizedToDate == null || !tripDate.isAfter(normalizedToDate);

        return isAfterStart && isBeforeEnd;
      })
      .toList(growable: false);
}

num _calculateOffersTotal(List<CompletedOfferEntity> offers) {
  return offers.fold<num>(
    0,
    (total, offer) => total + parseTripAmount(offer.price),
  );
}

num _parsePercentage(String rawValue) {
  final normalized = rawValue.trim().replaceAll(',', '.');
  final percentage = num.tryParse(normalized);

  if (percentage == null || percentage.isNaN || percentage.isInfinite) {
    return 0;
  }

  if (percentage < 0) return 0;
  if (percentage > 100) return 100;

  return percentage;
}

DateTime? _dateOnly(DateTime? value) {
  if (value == null) return null;

  return DateTime(value.year, value.month, value.day);
}

DateTime? _endOfDay(DateTime? value) {
  if (value == null) return null;

  return DateTime(value.year, value.month, value.day, 23, 59, 59, 999);
}

num _parsePriceValue(String rawValue) {
  return parseTripAmount(rawValue);
}
