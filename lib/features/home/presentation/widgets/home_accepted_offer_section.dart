import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';
import 'package:taxi_driver_app/features/home/domain/entities/offer_entity.dart';
import 'package:taxi_driver_app/features/home/presentation/controllers/complete_order_controller.dart';
import 'package:taxi_driver_app/features/home/presentation/widgets/current_request_card/current_offer_card.dart';

class HomeAcceptedOfferSection extends ConsumerWidget {
  const HomeAcceptedOfferSection({
    required this.accepted,
    required this.doneEndsAt,
    super.key,
  });

  final OfferAcceptedEntity accepted;
  final DateTime? doneEndsAt;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    final notes = accepted.notes;
    final phoneNumber = accepted.customerPhone;

    // /orders/current may not provide pickup/dropoff.
    final pickupText = accepted.pickup.trim().isNotEmpty
        ? accepted.pickup
        : l10n.unknown;

    final dropoffText = (accepted.dropoff?.trim().isNotEmpty ?? false)
        ? accepted.dropoff!
        : l10n.unknown;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CurrentOfferCard.accepted(
          notes: notes ?? '',
          badgeTitle: accepted.type,
          priceText: '${accepted.price} SYP',
          pickup: pickupText,
          dropoff: dropoffText,
          phoneNumber: phoneNumber,
          endsAt: doneEndsAt,
          isNotes: notes?.isNotEmpty ?? false,
          primaryActionLabel: l10n.tripCompleted,
          countdownPrefix: l10n.homeAvailableIn,
          onPrimaryAction: () async {
            final completeState = ref.read(completeOrderControllerProvider);
            if (completeState.isLoading) return;

            await ref
                .read(completeOrderControllerProvider.notifier)
                .complete(orderId: accepted.offerId);
          },
        ),
        AppSpacing.h16,
      ],
    );
  }
}
