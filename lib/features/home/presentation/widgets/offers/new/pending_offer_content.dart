import 'package:bawabat_al_saeq/features/home/presentation/widgets/offers/new/new_offer_actions.dart';
import 'package:bawabat_al_saeq/features/home/presentation/widgets/offers/shared/offer_main_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PendingOfferContent extends StatelessWidget {
  const PendingOfferContent({
    required this.statusLabel,
    required this.totalFare,
    required this.pickup,
    required this.isAcceptLoading,
    required this.isDeclineLoading,
    this.expiresAt,
    this.dropoff,
    this.onAccept,
    this.onDecline,
    super.key,
  });

  final String statusLabel;
  final DateTime? expiresAt;
  final String totalFare;
  final String pickup;
  final String? dropoff;
  final bool isAcceptLoading;
  final bool isDeclineLoading;
  final VoidCallback? onAccept;
  final VoidCallback? onDecline;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OfferMainDetails(
          statusLabel: statusLabel,
          expiresAt: expiresAt,
          totalFare: totalFare,
          pickup: pickup,
          dropoff: dropoff,
        ),
        SizedBox(height: 20.h),
        NewOfferActions(
          isAcceptLoading: isAcceptLoading,
          isDeclineLoading: isDeclineLoading,
          onAccept: onAccept,
          onDecline: onDecline,
        ),
      ],
    );
  }
}
