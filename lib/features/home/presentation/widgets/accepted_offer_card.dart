import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/features/home/presentation/controllers/accept_offer_controller.dart';
import 'package:taxi_driver_app/features/home/presentation/controllers/complete_offer_controller.dart';
import 'package:taxi_driver_app/features/home/presentation/widgets/current_request_card/base_offer_card.dart';

class AcceptedOfferCard extends ConsumerWidget {
  const AcceptedOfferCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncAcceptedOffer = ref.watch(accepteOfferControllerProvider);
    final acceptedOffer = asyncAcceptedOffer.value?.offerAcceptedEntity;

    if (acceptedOffer == null) {
      return const SizedBox.shrink();
    }

    return BaseOfferCard.acceptedOffer(
      statusOffer: acceptedOffer.type,
      totalFare: acceptedOffer.price,

      pickup: acceptedOffer.pickup,
      dropoff: acceptedOffer.dropoff ?? '',

      customerPhone: acceptedOffer.customerPhone,

      cooldownUntil: acceptedOffer.cooldownUntil,

      actionCompletedOffer: () async {
        await ref
            .read(completeOfferControllerProvider.notifier)
            .complete(offerId: acceptedOffer.offerId);
      },

      notes: acceptedOffer.notes ?? '',
    );
  }
}
