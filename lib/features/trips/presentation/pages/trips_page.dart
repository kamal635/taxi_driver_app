import 'dart:async' show unawaited;

import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/app/theme/app_theme_colors.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/features/trips/presentation/controllers/completed_offers_controller.dart';
import 'package:bawabat_al_saeq/features/trips/presentation/listeners/trips_error_listener.dart';
import 'package:bawabat_al_saeq/features/trips/presentation/view_models/trips_commission_view_data.dart';
import 'package:bawabat_al_saeq/features/trips/presentation/view_models/trips_summary_view_data.dart';
import 'package:bawabat_al_saeq/features/trips/presentation/widgets/commission/trips_commission_calculator_sheet.dart';
import 'package:bawabat_al_saeq/features/trips/presentation/widgets/commission/trips_commission_entry_card.dart';
import 'package:bawabat_al_saeq/features/trips/presentation/widgets/summary/trips_summary_card.dart';
import 'package:bawabat_al_saeq/features/trips/presentation/widgets/trips_content_section.dart';
import 'package:bawabat_al_saeq/features/trips/presentation/widgets/trips_filter_dropdown.dart';
import 'package:bawabat_al_saeq/features/trips/presentation/widgets/trips_section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TripsPage extends ConsumerWidget {
  const TripsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripsState = ref.watch(completedOffersControllerProvider);
    final summaryData = TripsSummaryViewData.fromResult(tripsState.result);
    final commissionData = TripsCommissionViewData.fromState(
      offers: summaryData.offers,
      fromDate: tripsState.commissionFromDate,
      toDate: tripsState.commissionToDate,
      percentageText: tripsState.commissionPercentageText,
    );
    final currency = context.l10n.currencySyrianPound;
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
                      tripsCountText: summaryData.tripsCount.toString(),
                      earningsLabel: context.l10n.tripsSummaryEarningsLabel,
                      earningsText: '$currency ${summaryData.totalProfitsText}',
                      averageFareLabel:
                          context.l10n.tripsSummaryAverageFareLabel,
                      averageFareText:
                          '$currency ${summaryData.averageFareText}',
                    ),
                    AppSpacing.h12,
                    TripsCommissionEntryCard(
                      title: context.l10n.tripsCommissionTitle,
                      subtitle: context.l10n.tripsCommissionSubtitle,
                      amountDueLabel:
                          context.l10n.tripsCommissionAmountDueLabel,
                      amountDueText:
                          '$currency ${commissionData.commissionAmountText}',
                      selectedTripsText: context.l10n.tripsTotalTrips(
                        commissionData.selectedTripsCount,
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
                      subtitle: context.l10n.tripsTotalTrips(
                        summaryData.tripsCount,
                      ),
                    ),
                    AppSpacing.h12,
                  ]),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                sliver: TripsContentSection(
                  offers: summaryData.offers,
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
      builder: (_) => const TripsCommissionCalculatorSheet(),
    ),
  );
}
