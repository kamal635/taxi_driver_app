import 'package:bawabat_al_saeq/features/home/domain/entities/offer_entity.dart';
import 'package:flutter/widgets.dart';

@immutable
final class AcceptOfferState {
  const AcceptOfferState({
    this.acceptedOffer,
    this.doneEndsAt,
  });

  final OfferAcceptedEntity? acceptedOffer;
  final DateTime? doneEndsAt;
}
