import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';
import 'package:taxi_driver_app/features/home/presentation/controllers/accepte_offer_controller.dart';
import 'package:taxi_driver_app/features/home/presentation/controllers/decline_offer_controller.dart';
import 'package:taxi_driver_app/features/home/presentation/controllers/new_offer_controller.dart';
import 'package:taxi_driver_app/features/home/presentation/widgets/home_accepted_offer_section.dart';
import 'package:taxi_driver_app/features/home/presentation/widgets/home_empty_state.dart';
import 'package:taxi_driver_app/features/home/presentation/widgets/home_new_offer_section.dart';

class HomeOffersSection extends ConsumerWidget {
  const HomeOffersSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    final newOfferAsync = ref.watch(newOfferControllerProvider);
    final acceptAsync = ref.watch(accepteOfferControllerProvider);
    final declineAsync = ref.watch(declineOfferControllerProvider);

    final accepted = acceptAsync.value?.offerAcceptedEntity;
    final doneEndsAt = acceptAsync.value?.doneEndsAt;
    final newOffer = newOfferAsync.value?.currentOffer;

    // First priority: show current accepted trip.
    if (accepted != null) {
      return HomeAcceptedOfferSection(
        accepted: accepted,
        doneEndsAt: doneEndsAt,
      );
    }

    // Second priority: show empty state.
    if (newOffer == null) {
      return Center(
        child: HomeEmptyState(
          icon: Icons.search_rounded,
          title: l10n.homeEmptyTitle,
          subtitle: l10n.homeEmptySubtitle,
        ),
      );
    }

    // Third priority: show incoming offer.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (newOfferAsync.isLoading)
          const CircularProgressIndicator(
            strokeWidth: 3,
            color: AppColors.primary,
          ),
        if (newOfferAsync.isLoading) AppSpacing.h16,
        HomeNewOfferSection(
          newOffer: newOffer,
          isActionLoading: acceptAsync.isLoading || declineAsync.isLoading,
        ),
        AppSpacing.h16,
      ],
    );
  }
}
