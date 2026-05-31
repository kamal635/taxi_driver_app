import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/features/home/presentation/widgets/offers/accepted/accepted_customer_phone_tile.dart';
import 'package:bawabat_al_saeq/features/home/presentation/widgets/offers/accepted/accepted_progress_timer.dart';
import 'package:bawabat_al_saeq/features/home/presentation/widgets/offers/shared/offer_header.dart';
import 'package:bawabat_al_saeq/features/home/presentation/widgets/offers/shared/offer_route_section.dart';
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
      children: [
        OfferHeader(
          statusLabel: statusLabel,
          totalFare: totalFare,
        ),
        AppSpacing.h24,
        OfferRouteSection(
          pickup: pickup,
          dropoff: dropoff,
        ),
        AppSpacing.h24,
        AcceptedCustomerPhoneTile(customerPhone: customerPhone),
        AppSpacing.h24,
        AcceptedProgressTimer(
          isCompletedLoading: isCompletedLoading,
          cooldownUntil: cooldownUntil,
          onComplete: onComplete,
        ),
      ],
    );
  }
}
