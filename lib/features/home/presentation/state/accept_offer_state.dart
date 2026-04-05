import 'package:flutter/widgets.dart';
import 'package:taxi_driver_app/features/home/domain/entities/offer_entity.dart';

@immutable
final class AcceptOfferState {
  const AcceptOfferState({
    this.acceptedOffer,
    this.doneEndsAt,
  });

  final OfferAcceptedEntity? acceptedOffer;
  final DateTime? doneEndsAt;
}
