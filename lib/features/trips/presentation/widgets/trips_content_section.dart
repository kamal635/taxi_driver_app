import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/core/constants/app_icons.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/features/trips/domain/entities/completed_offer_entity.dart';
import 'package:bawabat_al_saeq/features/trips/presentation/widgets/completed_trip_card.dart';
import 'package:bawabat_al_saeq/features/trips/presentation/widgets/trips_empty_state.dart';
import 'package:bawabat_al_saeq/features/trips/presentation/widgets/trips_loading_state.dart';
import 'package:flutter/material.dart';

class TripsContentSection extends StatelessWidget {
  const TripsContentSection({
    required this.offers,
    required this.isInitialLoading,
    required this.isRefreshing,
    super.key,
  });

  final List<CompletedOfferEntity> offers;
  final bool isInitialLoading;
  final bool isRefreshing;

  @override
  Widget build(BuildContext context) {
    if (isInitialLoading) {
      return const TripsLoadingState();
    }

    if (offers.isEmpty) {
      return TripsEmptyState(
        icon: AppIcons.car,
        title: context.l10n.tripsEmptyTitle,
        subtitle: context.l10n.tripsEmptySubtitle,
      );
    }

    return Column(
      children: [
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: offers.length,
          separatorBuilder: (_, _) => AppSpacing.h4,
          itemBuilder: (context, index) {
            final offer = offers[index];

            return CompletedTripCard(offer: offer);
          },
        ),
      ],
    );
  }
}
