import 'package:bawabat_al_saeq/features/home/presentation/widgets/offers/shared/offer_countdown_pill.dart';
import 'package:flutter/material.dart';

/// Backward-compatible pending countdown chip.
class PendingOfferCountdownPill extends StatelessWidget {
  const PendingOfferCountdownPill({
    required this.expiresAt,
    super.key,
  });

  final DateTime expiresAt;

  @override
  Widget build(BuildContext context) {
    return OfferCountdownPill(expiresAt: expiresAt);
  }
}
