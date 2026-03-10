import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/features/home/presentation/controllers/accepte_offer_controller.dart';
import 'package:taxi_driver_app/features/home/presentation/controllers/complete_order_controller.dart';
import 'package:taxi_driver_app/features/home/presentation/widgets/current_request_card/current_offer_card.dart';

class AcceptedOfferCard extends ConsumerWidget {
  const AcceptedOfferCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncAcceptedOffer = ref.watch(accepteOfferControllerProvider);
    final acceptedOffer = asyncAcceptedOffer.value?.offerAcceptedEntity;

    if (acceptedOffer == null) {
      return const SizedBox.shrink();
    }

    return CurrentOfferCard.acceptedOffer(
      statusOffer: acceptedOffer.type,
      totalFare: acceptedOffer.price,

      pickup: acceptedOffer.pickup,
      dropoff: acceptedOffer.dropoff ?? '',

      customerPhone: acceptedOffer.customerPhone,

      cooldownUntil: acceptedOffer.cooldownUntil,

      actionCompletedOffer: () async {
        await ref
            .read(completeOrderControllerProvider.notifier)
            .complete(orderId: acceptedOffer.offerId);
      },

      notes: acceptedOffer.notes ?? '',
    );
  }
}
