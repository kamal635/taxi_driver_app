import 'package:flutter/foundation.dart';

@immutable
sealed class OfferEntity {
  const OfferEntity({
    required this.type,
    required this.offerId,
    required this.pickup,
    required this.price,
    this.dropoff,
  });

  final String type;
  final String offerId;
  final String pickup;
  final String? dropoff;
  final String price;
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
    this.notes,
  });

  final String customerPhone;
  final String? notes;

  /// Server authority: when Done becomes allowed.
  final DateTime cooldownUntil;
}
