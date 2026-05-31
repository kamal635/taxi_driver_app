import 'package:bawabat_al_saeq/features/home/presentation/widgets/offers/accepted/accepted_offer_content.dart';
import 'package:bawabat_al_saeq/features/home/presentation/widgets/offers/new/pending_offer_content.dart';
import 'package:bawabat_al_saeq/features/home/presentation/widgets/offers/shared/offer_card_with_notes.dart';
import 'package:flutter/material.dart';

/// Shared offer card shell used by both pending and accepted states.
class OfferCard extends StatelessWidget {
  const OfferCard._({
    required this.child,
    this.notes,
  });

  factory OfferCard.pending({
    required String statusLabel,
    required DateTime expiresAt,
    required String totalFare,
    required String pickup,
    String? dropoff,
    String? notes,
    bool isAcceptLoading = false,
    bool isDeclineLoading = false,
    VoidCallback? onAccept,
    VoidCallback? onDecline,
  }) {
    return OfferCard._(
      notes: notes,
      child: PendingOfferContent(
        statusLabel: statusLabel,
        expiresAt: expiresAt,
        totalFare: totalFare,
        pickup: pickup,
        dropoff: dropoff,
        isAcceptLoading: isAcceptLoading,
        isDeclineLoading: isDeclineLoading,
        onAccept: onAccept,
        onDecline: onDecline,
      ),
    );
  }

  factory OfferCard.accepted({
    required String statusLabel,
    required String totalFare,
    required String pickup,
    required String customerPhone,
    required DateTime cooldownUntil,
    required bool isCompletedLoading,
    String? dropoff,
    String? notes,
    VoidCallback? onComplete,
  }) {
    return OfferCard._(
      notes: notes,
      child: AcceptedOfferContent(
        statusLabel: statusLabel,
        totalFare: totalFare,
        pickup: pickup,
        dropoff: dropoff,
        customerPhone: customerPhone,
        cooldownUntil: cooldownUntil,
        isCompletedLoading: isCompletedLoading,
        onComplete: onComplete,
      ),
    );
  }

  final Widget child;
  final String? notes;

  @override
  Widget build(BuildContext context) {
    return OfferCardWithNotes(
      notes: notes,
      child: child,
    );
  }
}
