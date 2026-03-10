import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';
import 'package:taxi_driver_app/features/home/presentation/controllers/accepte_offer_controller.dart';
import 'package:taxi_driver_app/features/home/presentation/controllers/new_offer_controller.dart';
import 'package:taxi_driver_app/features/home/presentation/widgets/accepted_offer_card.dart';
import 'package:taxi_driver_app/features/home/presentation/widgets/home_empty_state.dart';
import 'package:taxi_driver_app/features/home/presentation/widgets/new_offer_card.dart';

class HomeOfferSection extends ConsumerWidget {
  const HomeOfferSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    final asyncNewOffer = ref.watch(newOfferControllerProvider);
    final asyncAcceptedOffer = ref.watch(accepteOfferControllerProvider);

    final newOffer = asyncNewOffer.value?.currentOffer;
    final acceptedOffer = asyncAcceptedOffer.value?.offerAcceptedEntity;

    if (newOffer != null) {
      return const NewOfferCard();
    }
    if (acceptedOffer != null) {
      return const AcceptedOfferCard();
    }

    return HomeEmptyState(
      icon: Icons.search_rounded,
      title: l10n.homeEmptyTitle,
      subtitle: l10n.homeEmptySubtitle,
    );
  }
}
