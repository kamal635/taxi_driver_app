import 'package:bawabat_al_saeq/features/home/presentation/widgets/offers/shared/offer_countdown_pill.dart';
import 'package:bawabat_al_saeq/features/home/presentation/widgets/offers/shared/offer_fare_card.dart';
import 'package:bawabat_al_saeq/features/home/presentation/widgets/offers/shared/offer_route_card.dart';
import 'package:bawabat_al_saeq/features/home/presentation/widgets/offers/shared/offer_section_divider.dart';
import 'package:bawabat_al_saeq/features/home/presentation/widgets/offers/shared/offer_status_pill.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Shared upper content for all offer states.
///
/// Pending and accepted offers must start with the same visual language:
/// status, fare, and route. State-specific sections are appended by each
/// content widget below this shared block.
class OfferMainDetails extends StatelessWidget {
  const OfferMainDetails({
    required this.statusLabel,
    required this.totalFare,
    required this.pickup,
    this.dropoff,
    this.expiresAt,
    super.key,
  });

  final String statusLabel;
  final String totalFare;
  final String pickup;
  final String? dropoff;
  final DateTime? expiresAt;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _OfferMainHeader(
          statusLabel: statusLabel,
          expiresAt: expiresAt,
        ),
        SizedBox(height: 18.h),
        OfferFareCard(totalFare: totalFare),
        const OfferSectionDivider(),
        OfferRouteCard(
          pickup: pickup,
          dropoff: dropoff,
        ),
      ],
    );
  }
}

class _OfferMainHeader extends StatelessWidget {
  const _OfferMainHeader({
    required this.statusLabel,
    this.expiresAt,
  });

  final String statusLabel;
  final DateTime? expiresAt;

  @override
  Widget build(BuildContext context) {
    final statusPill = OfferStatusPill(label: statusLabel);

    if (expiresAt == null) {
      return Row(
        children: [statusPill],
      );
    }

    return Row(
      children: [
        statusPill,
        SizedBox(width: 8.w),
        const Spacer(),
        OfferCountdownPill(expiresAt: expiresAt!),
      ],
    );
  }
}
