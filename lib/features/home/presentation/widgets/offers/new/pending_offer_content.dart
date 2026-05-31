import 'package:bawabat_al_saeq/features/home/presentation/widgets/offers/new/new_offer_actions.dart';
import 'package:bawabat_al_saeq/features/home/presentation/widgets/offers/new/pending_offer_countdown_pill.dart';
import 'package:bawabat_al_saeq/features/home/presentation/widgets/offers/new/pending_offer_fare_card.dart';
import 'package:bawabat_al_saeq/features/home/presentation/widgets/offers/new/pending_offer_route_card.dart';
import 'package:bawabat_al_saeq/features/home/presentation/widgets/offers/new/pending_offer_status_pill.dart';
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
        Row(
          children: [
            Expanded(
              child: PendingOfferStatusPill(label: statusLabel),
            ),
            if (expiresAt != null) ...[
              SizedBox(width: 8.w),
              PendingOfferCountdownPill(expiresAt: expiresAt!),
            ],
          ],
        ),
        SizedBox(height: 16.h),
        PendingOfferFareCard(totalFare: totalFare),
        SizedBox(height: 16.h),
        PendingOfferRouteCard(
          pickup: pickup,
          dropoff: dropoff,
        ),
        SizedBox(height: 18.h),
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
