import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/app/theme/app_theme_colors.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/core/utils/price_formatter.dart';
import 'package:bawabat_al_saeq/features/trips/domain/entities/completed_offer_entity.dart';
import 'package:bawabat_al_saeq/features/trips/presentation/controllers/completed_offers_controller.dart';
import 'package:bawabat_al_saeq/features/trips/presentation/listeners/trips_error_listener.dart';
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
    final totalProfitsText = formatOrderPrice(
      _formatNumberForPrice(totalProfitsValue),
    );
    final averageFareValue = tripsCount == 0
        ? 0
        : totalProfitsValue / tripsCount;
    final averageFareText = formatOrderPrice(
      _formatNumberForPrice(averageFareValue),
    );
    final currency = context.l10n.currencySyrianPound;

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
                      tripsCountText: context.l10n.tripsTotalTrips(tripsCount),
                      earningsLabel: context.l10n.tripsSummaryEarningsLabel,
                      earningsText: '$currency $totalProfitsText',
                      averageFareLabel:
                          context.l10n.tripsSummaryAverageFareLabel,
                      averageFareText: '$currency $averageFareText',
                    ),
                    AppSpacing.h14,
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

num _parsePriceValue(String rawValue) {
  final trimmed = rawValue.trim();
  if (trimmed.isEmpty) return 0;

  final directValue = num.tryParse(trimmed.replaceAll(',', ''));
  if (directValue != null) return directValue;

  final cleaned = trimmed.replaceAll(RegExp('[^0-9,.-]'), '');
  if (cleaned.isEmpty) return 0;

  final normalized = cleaned.contains(',') && cleaned.contains('.')
      ? cleaned.replaceAll(',', '')
      : cleaned.replaceAll(',', '.');

  return num.tryParse(normalized) ?? 0;
}

String _formatNumberForPrice(num value) {
  if (value.isNaN || value.isInfinite) return '0';

  return value.round().toString();
}
