import 'package:flutter/material.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/features/home/presentation/widgets/current_request_card/accepted_customer_phone.dart';
import 'package:taxi_driver_app/features/home/presentation/widgets/current_request_card/accepted_progress_timer.dart';
import 'package:taxi_driver_app/features/home/presentation/widgets/current_request_card/header_offer_card.dart';
import 'package:taxi_driver_app/features/home/presentation/widgets/current_request_card/new_offer_actions.dart';
import 'package:taxi_driver_app/features/home/presentation/widgets/current_request_card/offer_notes.dart';
import 'package:taxi_driver_app/features/home/presentation/widgets/current_request_card/route_pickup_and_dropoff.dart';
import 'package:taxi_driver_app/features/home/presentation/widgets/offer_card_surface.dart';
import 'package:taxi_driver_app/features/home/presentation/widgets/offer_type.dart';

class BaseOfferCard extends StatelessWidget {
  const BaseOfferCard._({
    required this.offerType,
    required this.statusOffer,
    required this.totalFare,
    required this.pickup,
    required this.dropoff,
    this.notes,
    this.expiresAt,
    this.customerPhone,
    this.cooldownUntil,
    this.actionCompletedOffer,
    this.accepteOffer,
    this.declineOffer,
    this.isLoadingAccepte,
    this.isLoadingDecline,
  });

  factory BaseOfferCard.newOffer({
    required String statusOffer,
    required DateTime expiresAt,
    required String totalFare,
    required String pickup,
    required String dropoff,
    required bool isLoadingAccepte,
    required bool isLoadingDecline,
    required VoidCallback? accepteOffer,
    required VoidCallback? declineOffer,
    required String notes,

    OfferType offerType = OfferType.newOffer,
  }) {
    return BaseOfferCard._(
      statusOffer: statusOffer,
      expiresAt: expiresAt,
      totalFare: totalFare,
      pickup: pickup,
      dropoff: dropoff,
      accepteOffer: accepteOffer,
      declineOffer: declineOffer,
      isLoadingAccepte: isLoadingAccepte,
      isLoadingDecline: isLoadingDecline,
      notes: notes,
      offerType: offerType,
    );
  }

  factory BaseOfferCard.acceptedOffer({
    required String statusOffer,
    required String totalFare,
    required String pickup,
    required String dropoff,
    required String customerPhone,
    required DateTime? cooldownUntil,
    required VoidCallback? actionCompletedOffer,
    required String notes,
    OfferType offerType = OfferType.acceptedOffer,
  }) {
    return BaseOfferCard._(
      statusOffer: statusOffer,
      totalFare: totalFare,
      pickup: pickup,
      dropoff: dropoff,
      customerPhone: customerPhone,
      cooldownUntil: cooldownUntil,
      actionCompletedOffer: actionCompletedOffer,
      notes: notes,
      offerType: offerType,
    );
  }

  /// Header
  final String statusOffer;
  final DateTime? expiresAt; // for new offer
  final String totalFare;

  /// Body
  final String pickup;
  final String dropoff;

  /// customer phone
  final String? customerPhone;

  /// timer and action accepted offer
  final DateTime? cooldownUntil;
  final VoidCallback? actionCompletedOffer;

  /// accepte and reject new offer
  final VoidCallback? accepteOffer;
  final VoidCallback? declineOffer;
  final bool? isLoadingAccepte;
  final bool? isLoadingDecline;

  /// notes
  final String? notes;

  final OfferType offerType;

  bool get isNewOffer => offerType == OfferType.newOffer;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OfferCardSurface(
          child: Column(
            children: [
              HeaderOfferCard(
                isExpiresAt: isNewOffer,
                statusOffer: statusOffer,
                totalFare: totalFare,
                expiresAt: expiresAt,
              ),

              AppSpacing.h24,

              RoutePickupAndDropoff(
                dropoff: dropoff,
                pickup: pickup,
              ),

              AppSpacing.h24,

              if (!isNewOffer)
                AcceptedCustomerPhone(
                  customerPhone: customerPhone ?? '',
                ),

              if (!isNewOffer && cooldownUntil != null) ...[
                AppSpacing.h24,
                AcceptedProgressTimer(
                  cooldownUntil: cooldownUntil!,
                  actionCompletedOffer: actionCompletedOffer,
                ),
              ],

              if (isNewOffer)
                NewOfferActions(
                  isLoadingAccepte: isLoadingAccepte ?? false,
                  isLoadingDecline: isLoadingDecline ?? false,
                  accepteOffer: accepteOffer,
                  declineOffer: declineOffer,
                ),
            ],
          ),
        ),
        if (notes != null && notes!.isNotEmpty) OfferNotes(notes: notes),

        AppSpacing.h32,
      ],
    );
  }
}
