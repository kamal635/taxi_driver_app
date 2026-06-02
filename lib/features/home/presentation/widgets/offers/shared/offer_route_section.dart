import 'package:bawabat_al_saeq/features/home/presentation/widgets/offers/shared/offer_route_card.dart';
import 'package:flutter/material.dart';

/// Backward-compatible route section for offer cards.
class OfferRouteSection extends StatelessWidget {
  const OfferRouteSection({
    required this.pickup,
    required this.dropoff,
    super.key,
  });

  final String pickup;
  final String? dropoff;

  @override
  Widget build(BuildContext context) {
    return OfferRouteCard(
      pickup: pickup,
      dropoff: dropoff,
    );
  }
}
