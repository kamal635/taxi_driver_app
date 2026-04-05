import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';
import 'package:taxi_driver_app/features/home/presentation/controllers/accept_offer_controller.dart';
import 'package:taxi_driver_app/features/home/presentation/controllers/decline_offer_controller.dart';
import 'package:taxi_driver_app/features/home/presentation/controllers/new_offer_controller.dart';
import 'package:taxi_driver_app/features/home/presentation/widgets/offers/offer_card.dart';

/// Card for a newly received pending offer.
class NewOfferCard extends ConsumerWidget {
  const NewOfferCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingOffer = ref.watch(
      newOfferControllerProvider.select(
        (state) => state.asData?.value.currentOffer,
      ),
    );
    final isAcceptLoading = ref.watch(
      acceptOfferControllerProvider.select((state) => state.isLoading),
    );
    final isDeclineLoading = ref.watch(
      declineOfferControllerProvider.select((state) => state.isLoading),
    );

    if (pendingOffer == null) {
      return const SizedBox.shrink();
    }

    return OfferCard.pending(
      statusLabel: context.l10n.homeRequestNewTitle,
      expiresAt: pendingOffer.expiresAt,
      totalFare: pendingOffer.price,
      pickup: pendingOffer.pickup,
      dropoff: pendingOffer.dropoff ?? '',
      notes: pendingOffer.notes,
      isAcceptLoading: isAcceptLoading,
      isDeclineLoading: isDeclineLoading,
      onAccept: () async {
        await ref
            .read(acceptOfferControllerProvider.notifier)
            .accept(offerId: pendingOffer.offerId);
      },
      onDecline: () async {
        await ref
            .read(declineOfferControllerProvider.notifier)
            .decline(offerId: pendingOffer.offerId);
      },
    );
  }
}
