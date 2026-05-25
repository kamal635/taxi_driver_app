import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/features/availability/presentation/providers/availability_providers.dart';
import 'package:bawabat_al_saeq/features/home/presentation/controllers/accept_offer_controller.dart';
import 'package:bawabat_al_saeq/features/home/presentation/controllers/decline_offer_controller.dart';
import 'package:bawabat_al_saeq/features/home/presentation/controllers/new_offer_controller.dart';
import 'package:bawabat_al_saeq/features/home/presentation/widgets/offers/offer_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        await ref.read(driverBackgroundServiceBridgeProvider).stopOfferAlert();
        await ref
            .read(acceptOfferControllerProvider.notifier)
            .accept(offerId: pendingOffer.offerId);
      },
      onDecline: () async {
        await ref.read(driverBackgroundServiceBridgeProvider).stopOfferAlert();
        await ref
            .read(declineOfferControllerProvider.notifier)
            .decline(offerId: pendingOffer.offerId);
      },
    );
  }
}
