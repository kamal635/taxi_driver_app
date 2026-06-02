import 'package:bawabat_al_saeq/features/home/presentation/widgets/offers/shared/offer_fare_card.dart';
import 'package:flutter/material.dart';

/// Backward-compatible pending fare block.
class PendingOfferFareCard extends StatelessWidget {
  const PendingOfferFareCard({
    required this.totalFare,
    super.key,
  });

  final String totalFare;

  @override
  Widget build(BuildContext context) {
    return OfferFareCard(totalFare: totalFare);
  }
}
