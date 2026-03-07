import 'package:taxi_driver_app/features/home/domain/entities/offer_entity.dart';

sealed class OfferModel {
  const OfferModel({
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

final class NewOfferModel extends OfferModel {
  const NewOfferModel({
    required super.type,
    required super.offerId,
    required super.pickup,
    required super.price,
    required this.expiresAt,
    super.dropoff,
  });

  factory NewOfferModel.fromJson(Map<String, dynamic> json) {
    return NewOfferModel(
      type: _requireString(json, 'type'),
      offerId: _requireString(json, 'orderId'),
      pickup: _requireString(json, 'pickupText'),
      dropoff: _optionalString(json, 'dropoffText'),
      price: _requireString(json, 'price'),
      expiresAt: _requireDateTime(json, 'expiresAt'),
    );
  }

  final DateTime expiresAt;

  NewOfferEntity toEntity() => NewOfferEntity(
    type: type,
    offerId: offerId,
    pickup: pickup,
    dropoff: dropoff,
    price: price,
    expiresAt: expiresAt,
  );
}

final class OfferAcceptedModel extends OfferModel {
  const OfferAcceptedModel({
    required super.type,
    required super.offerId,
    required super.pickup,
    required super.price,
    required this.customerPhone,
    required this.cooldownUntil,
    super.dropoff,
    this.note,
  });

  factory OfferAcceptedModel.fromJson(Map<String, dynamic> json) {
    return OfferAcceptedModel(
      type: _requireString(json, 'type'),
      offerId: _requireString(json, 'orderId'),
      pickup: _requireString(json, 'pickupText'),
      dropoff: _optionalString(json, 'dropoffText'),
      price: _requireString(json, 'price'),
      customerPhone: _requireString(json, 'customerPhone'),
      note: _optionalString(json, 'note'),
      cooldownUntil: _requireDateTime(json, 'cooldownUntil'),
    );
  }

  final String customerPhone;
  final String? note;
  final DateTime cooldownUntil;

  OfferAcceptedEntity toEntity() => OfferAcceptedEntity(
    type: type,
    offerId: offerId,
    pickup: pickup,
    dropoff: dropoff,
    price: price,
    customerPhone: customerPhone,
    notes: note,
    cooldownUntil: cooldownUntil,
  );
}

// --------------------
// Small JSON helpers
// --------------------

String _requireString(Map<String, dynamic> json, String key) {
  final v = json[key];
  if (v == null) throw FormatException('Missing $key');
  final s = v.toString().trim();
  if (s.isEmpty) throw FormatException('Empty $key');
  return s;
}

String? _optionalString(Map<String, dynamic> json, String key) {
  final v = json[key];
  if (v == null) return null;
  final s = v.toString().trim();
  return s.isEmpty ? null : s;
}

DateTime _requireDateTime(Map<String, dynamic> json, String key) {
  final raw = json[key];
  if (raw == null) throw FormatException('Missing $key');
  return DateTime.parse(raw.toString());
}
