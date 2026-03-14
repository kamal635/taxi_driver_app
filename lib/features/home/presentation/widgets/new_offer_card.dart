import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/features/home/presentation/controllers/accept_offer_controller.dart';
import 'package:taxi_driver_app/features/home/presentation/controllers/decline_offer_controller.dart';
import 'package:taxi_driver_app/features/home/presentation/controllers/new_offer_controller.dart';
import 'package:taxi_driver_app/features/home/presentation/widgets/current_request_card/base_offer_card.dart';

class NewOfferCard extends ConsumerWidget {
  const NewOfferCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncNewOffer = ref.watch(newOfferControllerProvider);
    final asyncDeclineOffer = ref.watch(declineOfferControllerProvider);
    final isLoadingAccepte = ref.watch(
      accepteOfferControllerProvider.select((s) => s.isLoading),
    );

    final newOffer = asyncNewOffer.value?.currentOffer;

    if (newOffer == null) {
      return const SizedBox.shrink();
    }

    return BaseOfferCard.newOffer(
      statusOffer: newOffer.type,
      expiresAt: newOffer.expiresAt,
      totalFare: newOffer.price,

      pickup: newOffer.pickup,
      dropoff: newOffer.dropoff ?? '',

      notes: newOffer.notes ?? '',

      /// action buttons
      accepteOffer: () async {
        await ref
            .read(accepteOfferControllerProvider.notifier)
            .accepte(offerId: newOffer.offerId);
      },
      isLoadingAccepte: isLoadingAccepte,

      declineOffer: () async {
        await ref
            .read(declineOfferControllerProvider.notifier)
            .decline(offerId: newOffer.offerId);
      },
      isLoadingDecline: asyncDeclineOffer.isLoading,
    );
  }
}
