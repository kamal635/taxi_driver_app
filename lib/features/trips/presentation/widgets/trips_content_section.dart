import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/core/constants/app_icons.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/features/trips/domain/entities/completed_offer_entity.dart';
import 'package:bawabat_al_saeq/features/trips/presentation/widgets/completed_trip_card.dart';
import 'package:bawabat_al_saeq/features/trips/presentation/widgets/trips_empty_state.dart';
import 'package:bawabat_al_saeq/shared/presentation/widgets/states/app_centered_loading.dart';
import 'package:flutter/material.dart';

class TripsContentSection extends StatelessWidget {
  const TripsContentSection({
    required this.offers,
    required this.isInitialLoading,
    super.key,
  });

  final List<CompletedOfferEntity> offers;
  final bool isInitialLoading;

  @override
  Widget build(BuildContext context) {
    if (isInitialLoading) {
      return const SliverToBoxAdapter(child: AppCenteredLoading());
    }

    if (offers.isEmpty) {
      return SliverToBoxAdapter(
        child: TripsEmptyState(
          icon: AppIcons.car,
          title: context.l10n.tripsEmptyTitle,
          subtitle: context.l10n.tripsEmptySubtitle,
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final isSeparator = index.isOdd;
          if (isSeparator) return AppSpacing.h4;

          final offerIndex = index ~/ 2;
          return CompletedTripCard(offer: offers[offerIndex]);
        },
        childCount: offers.length * 2 - 1,
      ),
    );
  }
}
