import 'package:bawabat_al_saeq/features/home/presentation/widgets/offers/accepted/accepted_customer_phone_tile.dart';
import 'package:bawabat_al_saeq/features/home/presentation/widgets/offers/accepted/accepted_progress_timer.dart';
import 'package:bawabat_al_saeq/features/home/presentation/widgets/offers/shared/offer_main_details.dart';
import 'package:bawabat_al_saeq/features/home/presentation/widgets/offers/shared/offer_section_divider.dart';
import 'package:flutter/material.dart';

class AcceptedOfferContent extends StatelessWidget {
  const AcceptedOfferContent({
    required this.statusLabel,
    required this.totalFare,
    required this.pickup,
    required this.customerPhone,
    required this.cooldownUntil,
    required this.isCompletedLoading,
    this.dropoff,
    this.onComplete,
    super.key,
  });

  final String statusLabel;
  final String totalFare;
  final String pickup;
  final String customerPhone;
  final DateTime cooldownUntil;
  final bool isCompletedLoading;
  final String? dropoff;
  final VoidCallback? onComplete;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OfferMainDetails(
          statusLabel: statusLabel,
          totalFare: totalFare,
          pickup: pickup,
          dropoff: dropoff,
        ),
        const OfferSectionDivider(),
        AcceptedCustomerPhoneTile(customerPhone: customerPhone),
        const OfferSectionDivider(),
        AcceptedProgressTimer(
          isCompletedLoading: isCompletedLoading,
          cooldownUntil: cooldownUntil,
          onComplete: onComplete,
        ),
      ],
    );
  }
}
