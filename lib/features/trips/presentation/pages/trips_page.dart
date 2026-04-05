import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/core/errors/failure_message_mapper.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';
import 'package:taxi_driver_app/core/extensions/snackbar_x.dart';
import 'package:taxi_driver_app/core/utils/price_formatter.dart';
import 'package:taxi_driver_app/features/trips/domain/entities/completed_offer_entity.dart';
import 'package:taxi_driver_app/features/trips/domain/entities/completed_offers_result_entity.dart';
import 'package:taxi_driver_app/features/trips/presentation/controllers/completed_offers_controller.dart';
import 'package:taxi_driver_app/features/trips/presentation/widgets/trips_content_section.dart';
import 'package:taxi_driver_app/features/trips/presentation/widgets/trips_filter_dropdown.dart';
import 'package:taxi_driver_app/features/trips/presentation/widgets/trips_section_header.dart';
import 'package:taxi_driver_app/features/trips/presentation/widgets/trips_summary_card.dart';

class TripsPage extends ConsumerWidget {
  const TripsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _listenForErrors(context, ref);

    final tripsState = ref.watch(completedOffersControllerProvider);
    final result = tripsState.result;
    final offers = result?.offers ?? const <CompletedOfferEntity>[];

    final isInitialLoading = tripsState.isLoading && result == null;
    final isRefreshing = tripsState.isRefreshing;

    return RefreshIndicator(
      onRefresh: () {
        return ref.read(completedOffersControllerProvider.notifier).refresh();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 90.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TripsSummaryCard(
              title: context.l10n.tripsSummaryTitle,
              earningsLabel: context.l10n.tripsSummaryEarningsLabel,
              earningsText:
                  'SYP ${formatOrderPrice(result?.totalProfits ?? "0")}',
            ),
            AppSpacing.h12,
            TripsFilterDropdown(
              value: result?.period ?? CompletedPeriod.all,
              enabled: !tripsState.isLoading && !tripsState.isRefreshing,
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
              subtitle: context.l10n.tripsTotalTrips(result?.count ?? 0),
            ),
            AppSpacing.h12,
            TripsContentSection(
              offers: offers,
              isInitialLoading: isInitialLoading,
              isRefreshing: isRefreshing,
            ),
            AppSpacing.h12,
          ],
        ),
      ),
    );
  }

  void _listenForErrors(BuildContext context, WidgetRef ref) {
    ref.listen<Object?>(
      completedOffersControllerProvider.select((state) => state.error),
      (previous, next) {
        if (next == null || identical(previous, next)) return;

        final message = failureToUserMessage(next, l10n: context.l10n);
        context.showAppSnack(message, type: AppSnackType.error);
      },
    );
  }
}
