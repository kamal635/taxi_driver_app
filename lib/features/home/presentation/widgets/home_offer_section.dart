import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';
import 'package:taxi_driver_app/features/home/presentation/controllers/accept_offer_controller.dart';
import 'package:taxi_driver_app/features/home/presentation/controllers/new_offer_controller.dart';
import 'package:taxi_driver_app/features/home/presentation/providers/offer_providers.dart';
import 'package:taxi_driver_app/features/home/presentation/widgets/home_empty_state.dart';
import 'package:taxi_driver_app/features/home/presentation/widgets/offers/accepted_offer_card.dart';
import 'package:taxi_driver_app/features/home/presentation/widgets/offers/new_offer_card.dart';

/// Resolves which home content should be visible right now.
class HomeOfferSection extends ConsumerWidget {
  const HomeOfferSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    final pendingOffer = ref.watch(
      newOfferControllerProvider.select(
        (state) => state.asData?.value.currentOffer,
      ),
    );
    final acceptedOffer = ref.watch(
      acceptOfferControllerProvider.select(
        (state) => state.asData?.value.acceptedOffer,
      ),
    );
    final restoredAcceptedOffer = ref.watch(restoredCurrentOfferProvider);

    if (pendingOffer != null) {
      return const NewOfferCard();
    }

    if (acceptedOffer != null || restoredAcceptedOffer != null) {
      return const AcceptedOfferCard();
    }

    return HomeEmptyState(
      icon: Icons.search_rounded,
      title: l10n.homeEmptyTitle,
      subtitle: l10n.homeEmptySubtitle,
    );
  }
}
