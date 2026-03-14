import 'package:taxi_driver_app/core/utils/json_reader.dart';
import 'package:taxi_driver_app/features/home/domain/entities/offer_entity.dart';

//-------------------------------------------
//           - Base Offer Model -
//-------------------------------------------

sealed class BaseOfferModel {
  const BaseOfferModel({
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

//-------------------------------------------
//            - New Offer Model -
//-------------------------------------------

final class NewOfferModel extends BaseOfferModel {
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
      type: JsonReader.requireString(json, 'type'),
      offerId: JsonReader.requireString(json, 'orderId'),
      pickup: JsonReader.requireString(json, 'pickupText'),
      dropoff: JsonReader.optionalString(json, 'dropoffText'),
      price: JsonReader.requireString(json, 'price'),
      expiresAt: JsonReader.requireDateTime(json, 'expiresAt'),
      notes: JsonReader.optionalString(json, 'note'),
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
    notes: notes,
  );
}

//-------------------------------------------
//            - Accepted Offer Model -
//-------------------------------------------

final class AccepteOfferdModel extends BaseOfferModel {
  const AccepteOfferdModel({
    required super.type,
    required super.offerId,
    required super.pickup,
    required super.price,
    required this.customerPhone,
    required this.cooldownUntil,
    super.dropoff,
    super.notes,
  });

  factory AccepteOfferdModel.fromJson(Map<String, dynamic> json) {
    return AccepteOfferdModel(
      type: JsonReader.requireString(json, 'type'),
      offerId: JsonReader.requireString(json, 'orderId'),
      pickup: JsonReader.requireString(json, 'pickupText'),
      dropoff: JsonReader.optionalString(json, 'dropoffText'),
      price: JsonReader.requireString(json, 'price'),
      customerPhone: JsonReader.requireString(json, 'customerPhone'),
      notes: JsonReader.optionalString(json, 'note'),
      cooldownUntil: JsonReader.requireDateTime(json, 'cooldownUntil'),
    );
  }

  final String customerPhone;
  final DateTime cooldownUntil;

  OfferAcceptedEntity toEntity() => OfferAcceptedEntity(
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
