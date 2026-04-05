import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';
import 'package:taxi_driver_app/features/home/presentation/controllers/accept_offer_controller.dart';
import 'package:taxi_driver_app/features/home/presentation/controllers/complete_offer_controller.dart';
import 'package:taxi_driver_app/features/home/presentation/providers/offer_providers.dart';
import 'package:taxi_driver_app/features/home/presentation/widgets/offers/offer_card.dart';

/// Card for the currently accepted offer.
class AcceptedOfferCard extends ConsumerWidget {
  const AcceptedOfferCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final acceptedOffer =
        ref.watch(
          acceptOfferControllerProvider.select(
            (state) => state.asData?.value.acceptedOffer,
          ),
        ) ??
        ref.watch(restoredCurrentOfferProvider);

    if (acceptedOffer == null) {
      return const SizedBox.shrink();
    }

    final isCompletedLoading = ref.watch(
      completeOfferControllerProvider.select((state) => state.isLoading),
    );
    return OfferCard.accepted(
      isCompletedLoading: isCompletedLoading,
      statusLabel: context.l10n.homeRequestCurrentTitle,
      totalFare: acceptedOffer.price,
      pickup: acceptedOffer.pickup,
      dropoff: acceptedOffer.dropoff ?? '',
      customerPhone: acceptedOffer.customerPhone,
      cooldownUntil: acceptedOffer.cooldownUntil,
      notes: acceptedOffer.notes,

      onComplete: () async {
        await ref
            .read(completeOfferControllerProvider.notifier)
            .complete(offerId: acceptedOffer.offerId);
      },
    );
  }
}
