import 'package:bawabat_al_saeq/core/utils/json_reader.dart';
import 'package:bawabat_al_saeq/features/home/domain/entities/offer_entity.dart';

/// Base structure shared by parsed offer models.
sealed class OfferModel {
  const OfferModel({
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
  final String? notes;
  final String price;
}

/// Data model for a newly received pending offer.
final class NewOfferModel extends OfferModel {
  const NewOfferModel({
    required super.type,
    required super.offerId,
    required super.pickup,
    required super.price,
    required this.expiresAt,
    super.dropoff,
    super.notes,
  });

  factory NewOfferModel.fromJson(Map<String, dynamic> json) {
    return NewOfferModel(
      type: JsonReader.requireAnyString(json, _OfferJsonKeys.type),
      offerId: JsonReader.requireAnyString(json, _OfferJsonKeys.offerId),
      pickup: JsonReader.requireAnyString(json, _OfferJsonKeys.pickup),
      dropoff: JsonReader.optionalAnyString(json, _OfferJsonKeys.dropoff),
      notes: JsonReader.optionalAnyString(json, _OfferJsonKeys.notes),
      price: JsonReader.requireAnyString(json, _OfferJsonKeys.price),
      expiresAt: JsonReader.requireAnyDateTime(json, _OfferJsonKeys.expiresAt),
    );
  }

  final DateTime expiresAt;

  NewOfferEntity toEntity() {
    return NewOfferEntity(
      type: type,
      offerId: offerId,
      pickup: pickup,
      dropoff: dropoff,
      price: price,
      expiresAt: expiresAt,
      notes: notes,
    );
  }
}

/// Data model returned after accepting an offer.
final class AcceptedOfferModel extends OfferModel {
  const AcceptedOfferModel({
    required super.type,
    required super.offerId,
    required super.pickup,
    required super.price,
    required this.customerPhone,
    required this.cooldownUntil,
    super.dropoff,
    super.notes,
  });

  factory AcceptedOfferModel.fromJson(Map<String, dynamic> json) {
    return AcceptedOfferModel(
      type: JsonReader.requireAnyString(json, _OfferJsonKeys.type),
      offerId: JsonReader.requireAnyString(json, _OfferJsonKeys.offerId),
      pickup: JsonReader.requireAnyString(json, _OfferJsonKeys.pickup),
      dropoff: JsonReader.optionalAnyString(json, _OfferJsonKeys.dropoff),
      notes: JsonReader.optionalAnyString(json, _OfferJsonKeys.notes),
      price: JsonReader.requireAnyString(json, _OfferJsonKeys.price),
      customerPhone: JsonReader.requireAnyString(
        json,
        _OfferJsonKeys.customerPhone,
      ),
      cooldownUntil: JsonReader.requireAnyDateTime(
        json,
        _OfferJsonKeys.cooldownUntil,
      ),
    );
  }

  final String customerPhone;
  final DateTime cooldownUntil;

  OfferAcceptedEntity toEntity() {
    return OfferAcceptedEntity(
      type: type,
      offerId: offerId,
      pickup: pickup,
      dropoff: dropoff,
      price: price,
      customerPhone: customerPhone,
      notes: notes,
      cooldownUntil: cooldownUntil,
    );
  }
}

final class _OfferJsonKeys {
  const _OfferJsonKeys._();

  static const type = ['type', 'order_status'];
  static const offerId = ['orderId', 'offerId', 'id', 'order_id'];
  static const pickup = [
    'pickupText',
    'pickup',
    'pickup_address',
    'pickup_text',
  ];
  static const dropoff = [
    'dropoffText',
    'dropoff',
    'dropoff_address',
    'dropoff_text',
  ];
  static const price = ['price', 'fare', 'total', 'total_fare'];
  static const expiresAt = ['expiresAt', 'expires_at'];
  static const cooldownUntil = ['cooldownUntil', 'cooldown_until'];
  static const customerPhone = ['customerPhone', 'customer_phone', 'phone'];
  static const notes = ['note', 'notes'];
}
