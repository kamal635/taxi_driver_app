import 'package:bawabat_al_saeq/core/utils/json_reader.dart';
import 'package:bawabat_al_saeq/features/trips/domain/entities/completed_offer_entity.dart';

/// Data model for a single completed trip.
final class CompletedOfferModel {
  const CompletedOfferModel({
    required this.offerId,
    required this.pickup,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
    this.dropoff,
  });

  factory CompletedOfferModel.fromJson(Map<String, dynamic> json) {
    final createdAt = JsonReader.optionalAnyDateTime(json, _createdAtKeys);
    final updatedAt = JsonReader.optionalAnyDateTime(json, _updatedAtKeys);
    final fallbackDateTime =
        updatedAt ??
        createdAt ??
        JsonReader.requireAnyDateTime(
          json,
          [..._updatedAtKeys, ..._createdAtKeys],
        );

    return CompletedOfferModel(
      offerId: JsonReader.requireAnyString(json, _idKeys),
      pickup: JsonReader.requireAnyString(json, _pickupKeys),
      dropoff: JsonReader.optionalAnyString(json, _dropoffKeys),
      price: JsonReader.requireAnyString(json, _priceKeys),
      createdAt: createdAt ?? fallbackDateTime,
      updatedAt: updatedAt ?? fallbackDateTime,
    );
  }

  static const List<String> _idKeys = [
    'id',
    'order_id',
    'orderId',
    'offer_id',
    'offerId',
  ];

  static const List<String> _pickupKeys = [
    'pickup_text',
    'pickupText',
    'pickup_address',
    'pickupAddress',
    'pickup',
  ];

  static const List<String> _dropoffKeys = [
    'dropoff_text',
    'dropoffText',
    'dropoff_address',
    'dropoffAddress',
    'dropoff',
    'destination',
  ];

  static const List<String> _priceKeys = [
    'price',
    'fare',
    'total_price',
    'totalPrice',
    'amount',
  ];

  static const List<String> _createdAtKeys = [
    'created_at',
    'createdAt',
    'requested_at',
    'requestedAt',
  ];

  static const List<String> _updatedAtKeys = [
    'updated_at',
    'updatedAt',
    'completed_at',
    'completedAt',
  ];

  final String offerId;
  final String pickup;
  final String? dropoff;
  final String price;
  final DateTime createdAt;
  final DateTime updatedAt;

  CompletedOfferEntity toEntity() {
    return CompletedOfferEntity(
      offerId: offerId,
      pickup: pickup,
      dropoff: dropoff,
      price: price,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
