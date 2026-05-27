import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/features/home/presentation/widgets/offers/accepted/accepted_customer_phone_tile.dart';
import 'package:bawabat_al_saeq/features/home/presentation/widgets/offers/accepted/accepted_progress_timer.dart';
import 'package:bawabat_al_saeq/features/home/presentation/widgets/offers/new/new_offer_actions.dart';
import 'package:bawabat_al_saeq/features/home/presentation/widgets/offers/shared/offer_card_surface.dart';
import 'package:bawabat_al_saeq/features/home/presentation/widgets/offers/shared/offer_header.dart';
import 'package:bawabat_al_saeq/features/home/presentation/widgets/offers/shared/offer_notes_card.dart';
import 'package:bawabat_al_saeq/features/home/presentation/widgets/offers/shared/offer_route_section.dart';
import 'package:flutter/material.dart';

/// Shared offer card shell used by both pending and accepted states.
class OfferCard extends StatelessWidget {
  const OfferCard._({
    required this.statusLabel,
    required this.totalFare,
    required this.pickup,
    required this.isPendingOffer,
    this.dropoff,
    this.notes,
    this.expiresAt,
    this.customerPhone,
    this.cooldownUntil,
    this.onComplete,
    this.onAccept,
    this.onDecline,
    this.isAcceptLoading = false,
    this.isDeclineLoading = false,
    this.isCompletedLoading = false,
  });

  factory OfferCard.pending({
    required String statusLabel,
    required DateTime expiresAt,
    required String totalFare,
    required String pickup,
    String? dropoff,
    String? notes,
    bool isAcceptLoading = false,
    bool isDeclineLoading = false,
    VoidCallback? onAccept,
    VoidCallback? onDecline,
  }) {
    return OfferCard._(
      statusLabel: statusLabel,
      totalFare: totalFare,
      pickup: pickup,
      dropoff: dropoff,
      notes: notes,
      expiresAt: expiresAt,
      isPendingOffer: true,
      onAccept: onAccept,
      onDecline: onDecline,
      isAcceptLoading: isAcceptLoading,
      isDeclineLoading: isDeclineLoading,
    );
  }

  factory OfferCard.accepted({
    required String statusLabel,
    required String totalFare,
    required String pickup,
    required String customerPhone,
    required DateTime cooldownUntil,
    required bool isCompletedLoading,
    String? dropoff,
    String? notes,
    VoidCallback? onComplete,
  }) {
    return OfferCard._(
      statusLabel: statusLabel,
      totalFare: totalFare,
      pickup: pickup,
      dropoff: dropoff,
      notes: notes,
      customerPhone: customerPhone,
      cooldownUntil: cooldownUntil,
      isPendingOffer: false,
      onComplete: onComplete,
      isCompletedLoading: isCompletedLoading,
    );
  }

  final String statusLabel;
  final String totalFare;
  final String pickup;
  final String? dropoff;
  final String? notes;
  final bool isPendingOffer;

  final DateTime? expiresAt;
  final String? customerPhone;
  final DateTime? cooldownUntil;

  final VoidCallback? onComplete;
  final VoidCallback? onAccept;
  final VoidCallback? onDecline;
  final bool isAcceptLoading;
  final bool isDeclineLoading;
  final bool isCompletedLoading;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OfferCardSurface(
          child: Column(
            children: [
              OfferHeader(
                statusLabel: statusLabel,
                totalFare: totalFare,
                expiresAt: expiresAt,
                showExpiryChip: isPendingOffer,
              ),
              AppSpacing.h24,
              OfferRouteSection(
                pickup: pickup,
                dropoff: dropoff,
              ),
              if (!isPendingOffer) ...[
                AppSpacing.h24,
                AcceptedCustomerPhoneTile(
                  customerPhone: customerPhone ?? '',
                ),
              ],
              if (!isPendingOffer && cooldownUntil != null) ...[
                AppSpacing.h24,
                AcceptedProgressTimer(
                  isCompletedLoading: isCompletedLoading,
                  cooldownUntil: cooldownUntil!,
                  onComplete: onComplete,
                ),
              ],
              if (isPendingOffer) ...[
                AppSpacing.h24,
                NewOfferActions(
                  isAcceptLoading: isAcceptLoading,
                  isDeclineLoading: isDeclineLoading,
                  onAccept: onAccept,
                  onDecline: onDecline,
                ),
              ],
            ],
          ),
        ),
        if (notes != null && notes!.trim().isNotEmpty)
          OfferNotesCard(notes: notes!.trim()),
        AppSpacing.h32,
      ],
    );
  }
}
