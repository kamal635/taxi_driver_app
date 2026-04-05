import 'package:flutter/foundation.dart';

@immutable
sealed class OfferEntity {
  const OfferEntity({
    required this.type,
    required this.offerId,
    required this.pickup,
    required this.price,
    this.dropoff,
    this.notes,
  });

  final String type;
  final String offerId;
  final String pickup;
  final String? dropoff;
  final String price;
  final String? notes;
}

@immutable
final class NewOfferEntity extends OfferEntity {
  const NewOfferEntity({
    required super.type,
    required super.offerId,
    required super.pickup,
    required super.price,
    required this.expiresAt,
    super.dropoff,
    super.notes,
  });

  final DateTime expiresAt;
}

@immutable
final class OfferAcceptedEntity extends OfferEntity {
  const OfferAcceptedEntity({
    required super.type,
    required super.offerId,
    required super.pickup,
    required super.price,
    required this.customerPhone,
    required this.cooldownUntil,
    super.dropoff,
    super.notes,
  });

  final String customerPhone;

  /// Server authority: when completing the offer becomes allowed.
  final DateTime cooldownUntil;
}
