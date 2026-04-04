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
    String requireString(List<String> keys) {
      for (final key in keys) {
        final value = json[key];
        final text = value?.toString().trim();

        if (text != null && text.isNotEmpty) {
          return text;
        }
      }

      throw FormatException('Missing required field: ${keys.join(" / ")}');
    }

    String? optionalString(List<String> keys) {
      for (final key in keys) {
        final value = json[key];
        final text = value?.toString().trim();

        if (text != null && text.isNotEmpty) {
          return text;
        }
      }

      return null;
    }

    DateTime requireDateTime(List<String> keys) {
      final raw = requireString(keys);
      final parsed = DateTime.tryParse(raw);

      if (parsed == null) {
        throw FormatException(
          'Invalid date field: ${keys.join(" / ")} -> $raw',
        );
      }

      return parsed;
    }

    return NewOfferModel(
      type: requireString([
        'type',
        'order_status',
      ]),
      offerId: requireString([
        'orderId',
        'offerId',
        'id',
        'order_id',
      ]),
      pickup: requireString([
        'pickupText',
        'pickup',
        'pickup_address',
        'pickup_text',
      ]),
      dropoff: optionalString([
        'dropoffText',
        'dropoff',
        'dropoff_address',
        'dropoff_text',
      ]),
      price: requireString([
        'price',
      ]),
      expiresAt: requireDateTime([
        'expiresAt',
        'expires_at',
      ]),
      notes: optionalString([
        'note',
        'notes',
      ]),
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
