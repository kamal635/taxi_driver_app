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
  });

  final String type;
  final String offerId;
  final String pickup;
  final String? dropoff;
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
  });

  factory NewOfferModel.fromJson(Map<String, dynamic> json) {
    return NewOfferModel(
      type: JsonReader.requireString(json, 'type'),
      offerId: JsonReader.requireString(json, 'orderId'),
      pickup: JsonReader.requireString(json, 'pickupText'),
      dropoff: JsonReader.optionalString(json, 'dropoffText'),
      price: JsonReader.requireString(json, 'price'),
      expiresAt: JsonReader.requireDateTime(json, 'expiresAt'),
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
    this.note,
  });

  factory AccepteOfferdModel.fromJson(Map<String, dynamic> json) {
    return AccepteOfferdModel(
      type: JsonReader.requireString(json, 'type'),
      offerId: JsonReader.requireString(json, 'orderId'),
      pickup: JsonReader.requireString(json, 'pickupText'),
      dropoff: JsonReader.optionalString(json, 'dropoffText'),
      price: JsonReader.requireString(json, 'price'),
      customerPhone: JsonReader.requireString(json, 'customerPhone'),
      note: JsonReader.optionalString(json, 'note'),
      cooldownUntil: JsonReader.requireDateTime(json, 'cooldownUntil'),
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
