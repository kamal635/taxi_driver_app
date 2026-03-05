import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/app/theme/app_typography.dart';
import 'package:taxi_driver_app/core/constants/app_icons.dart';
import 'package:taxi_driver_app/core/errors/failure_message_mapper.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';
import 'package:taxi_driver_app/core/extensions/snackbar_x.dart';
import 'package:taxi_driver_app/features/trips/domain/entities/completed_offer_entity.dart';
import 'package:taxi_driver_app/features/trips/domain/entities/completed_offers_result_entity.dart';
import 'package:taxi_driver_app/features/trips/presentation/controllers/completed_offers_controller.dart';
import 'package:taxi_driver_app/features/trips/presentation/widgets/trip_card.dart';
import 'package:taxi_driver_app/features/trips/presentation/widgets/trips_empty_state.dart';
import 'package:taxi_driver_app/features/trips/presentation/widgets/trips_filters.dart';
import 'package:taxi_driver_app/features/trips/presentation/widgets/trips_summary_card.dart';
import 'package:taxi_driver_app/l10n/app_localizations.dart';

class TripsPage extends ConsumerWidget {
  const TripsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final asyncState = ref.watch(completedOffersControllerProvider);
    final result = asyncState.value;
    final offers = result?.offers ?? <CompletedOfferEntity>[];

    final isInitialLoading = asyncState.isLoading && result == null;
    final isRefreshing = asyncState.isLoading && result != null;

    ref.listen<Object?>(
      completedOffersControllerProvider.select((state) => state.error),
      (previous, next) {
        if (next == null) return;
        if (identical(previous, next)) return;

        final msg = failureToUserMessage(next, l10n: l10n);
        context.showAppSnack(msg, type: AppSnackType.error);
      },
    );

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 90.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TripsSummaryCard(
            title: l10n.tripsSummaryTitle,
            tripsLabel: l10n.tripsSummaryTripsLabel,
            earningsLabel: l10n.tripsSummaryEarningsLabel,
            tripsCountText: '${result?.count ?? 0}',
            earningsText: 'SYP ${_calculateTotalEarnings(offers)}',
          ),

          AppSpacing.h12,

          FilterDropdown(
            value: result?.period ?? CompletedPeriod.all,
            enabled: !asyncState.isLoading,
            onChanged: (value) async {
              if (value == null) return;

              await ref
                  .read(completedOffersControllerProvider.notifier)
                  .getCompletedOffers(value);
            },
          ),

          AppSpacing.h18,

          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                l10n.tripsRecentTitle,
                style: AppTypography.titleSm,
              ),
              AppSpacing.w8,
              Expanded(
                child: Text(
                  l10n.tripsTotalTrips(result?.count ?? 0),
                  style: AppTypography.subtitleSm,
                ),
              ),
            ],
          ),

          AppSpacing.h12,

          if (isInitialLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                  strokeWidth: 3,
                ),
              ),
            )
          else if (offers.isEmpty)
            TripsEmptyState(
              icon: AppIcons.car,
              title: l10n.tripsEmptyTitle,
              subtitle: l10n.tripsEmptySubtitle,
            )
          else
            Column(
              children: [
                if (isRefreshing)
                  Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: const LinearProgressIndicator(
                      color: AppColors.primary,
                      minHeight: 3,
                    ),
                  ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: offers.length,
                  separatorBuilder: (_, _) => AppSpacing.h12,
                  itemBuilder: (context, index) {
                    final offer = offers[index];

                    return TripCard(
                      placeTitle: offer.pickup,
                      timeText: formatCompletedTripTime(
                        context,
                        offer.updatedAt,
                        l10n: context.l10n,
                      ),
                      fareText: 'SYP ${offer.price}',
                      onTap: () {
                        // later: open details page
                      },
                    );
                  },
                ),
              ],
            ),

          AppSpacing.h12,
        ],
      ),
    );
  }

  String formatCompletedTripTime(
    BuildContext context,
    DateTime dateTime, {
    required AppLocalizations l10n,
  }) {
    final local = dateTime.toLocal();
    final now = DateTime.now();

    final todayStart = DateTime(now.year, now.month, now.day);
    final tripDayStart = DateTime(local.year, local.month, local.day);

    final daysDifference = todayStart.difference(tripDayStart).inDays;

    final material = MaterialLocalizations.of(context);
    final timeText = material.formatTimeOfDay(
      TimeOfDay.fromDateTime(local),
      alwaysUse24HourFormat: MediaQuery.of(context).alwaysUse24HourFormat,
    );

    if (daysDifference == 0) {
      return '${l10n.todayLabel} $timeText';
    }

    if (daysDifference == 1) {
      return '${l10n.yesterdayLabel} $timeText';
    }

    if (daysDifference > 1 && daysDifference < 7) {
      final weekdayText = _weekdayLabel(local.weekday, l10n);
      return '$weekdayText $timeText';
    }

    final dateText = material.formatShortDate(local);
    return '$dateText $timeText';
  }

  String _weekdayLabel(int weekday, AppLocalizations l10n) {
    switch (weekday) {
      case DateTime.monday:
        return l10n.weekdayMonday;
      case DateTime.tuesday:
        return l10n.weekdayTuesday;
      case DateTime.wednesday:
        return l10n.weekdayWednesday;
      case DateTime.thursday:
        return l10n.weekdayThursday;
      case DateTime.friday:
        return l10n.weekdayFriday;
      case DateTime.saturday:
        return l10n.weekdaySaturday;
      case DateTime.sunday:
        return l10n.weekdaySunday;
      default:
        return '';
    }
  }

  int _calculateTotalEarnings(List<CompletedOfferEntity> offers) {
    var total = 0;

    for (final offer in offers) {
      total += int.tryParse(offer.price) ?? 0;
    }

    return total;
  }
}
