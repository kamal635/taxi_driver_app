import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/features/home/presentation/widgets/offers/shared/offer_countdown_pill.dart';
import 'package:bawabat_al_saeq/features/home/presentation/widgets/offers/shared/offer_fare_card.dart';
import 'package:bawabat_al_saeq/features/home/presentation/widgets/offers/shared/offer_status_pill.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Backward-compatible header built from the shared offer blocks.
class OfferHeader extends StatelessWidget {
  const OfferHeader({
    required this.statusLabel,
    required this.totalFare,
    this.expiresAt,
    this.showExpiryChip = false,
    super.key,
  });

  final String statusLabel;
  final DateTime? expiresAt;
  final String totalFare;
  final bool showExpiryChip;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            OfferStatusPill(label: statusLabel),
            if (showExpiryChip && expiresAt != null) ...[
              const Spacer(),
              SizedBox(width: 8.w),
              OfferCountdownPill(
                expiresAt: expiresAt!,
                labelPrefix: context.l10n.homeOfferExpiresIn,
              ),
            ],
          ],
        ),
        SizedBox(height: 16.h),
        OfferFareCard(totalFare: totalFare),
      ],
    );
  }
}

/// Backward-compatible alias for older imports.
class OfferStatusChip extends StatelessWidget {
  const OfferStatusChip({
    required this.label,
    super.key,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return OfferStatusPill(label: label);
  }
}

/// Backward-compatible alias for older imports.
class OfferExpiryChip extends StatelessWidget {
  const OfferExpiryChip({
    required this.expiresAt,
    super.key,
  });

  final DateTime expiresAt;

  @override
  Widget build(BuildContext context) {
    return OfferCountdownPill(
      expiresAt: expiresAt,
      labelPrefix: context.l10n.homeOfferExpiresIn,
    );
  }
}
