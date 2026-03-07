import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';
import 'package:taxi_driver_app/features/home/domain/entities/offer_entity.dart';
import 'package:taxi_driver_app/features/home/presentation/controllers/accepte_offer_controller.dart';
import 'package:taxi_driver_app/features/home/presentation/controllers/decline_offer_controller.dart';
import 'package:taxi_driver_app/features/home/presentation/controllers/new_offer_controller.dart';
import 'package:taxi_driver_app/features/home/presentation/widgets/current_request_card/current_offer_card.dart';

class HomeNewOfferSection extends ConsumerWidget {
  const HomeNewOfferSection({
    required this.newOffer,
    required this.isActionLoading,
    super.key,
  });

  final NewOfferEntity newOffer;
  final bool isActionLoading;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final acceptAsync = ref.watch(accepteOfferControllerProvider);

    return CurrentOfferCard.offer(
      isLoading: isActionLoading,
      badgeTitle: newOffer.type,
      priceText: '${newOffer.price} SYP',
      pickup: newOffer.pickup,
      dropoff: newOffer.dropoff ?? l10n.unknown,
      acceptLabel: l10n.actionAccept,
      rejectLabel: l10n.actionReject,
      expiresAt: newOffer.expiresAt,
      expiresPrefix: l10n.homeOfferExpiresIn,
      onAccept: acceptAsync.isLoading
          ? null
          : () async {
              await ref
                  .read(accepteOfferControllerProvider.notifier)
                  .accepte(offeroId: newOffer.offerId);
            },
      onReject: isActionLoading
          ? null
          : () async {
              await ref
                  .read(declineOfferControllerProvider.notifier)
                  .decline(offeroId: newOffer.offerId);
            },
      onExpired: () {
        unawaited(
          ref.read(newOfferControllerProvider.notifier).clearCurrent(),
        );
      },
    );
  }
}
