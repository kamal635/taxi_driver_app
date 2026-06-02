import 'package:bawabat_al_saeq/features/home/presentation/widgets/offers/shared/offer_status_pill.dart';
import 'package:flutter/material.dart';

/// Backward-compatible pending status chip.
class PendingOfferStatusPill extends StatelessWidget {
  const PendingOfferStatusPill({
    required this.label,
    super.key,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return OfferStatusPill(label: label);
  }
}
