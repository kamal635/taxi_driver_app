import 'package:taxi_driver_app/core/utils/json_reader.dart';
import 'package:taxi_driver_app/features/trips/domain/entities/completed_offer_entity.dart';

final class CompletedOfferModel {
  CompletedOfferModel({
    required this.offerId,
    required this.pickup,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
    this.dropoff,
  });

  factory CompletedOfferModel.fromJson(Map<String, dynamic> json) {
    return CompletedOfferModel(
      offerId: JsonReader.requireString(json, 'id'),
      pickup: JsonReader.requireString(json, 'pickup_text'),
      dropoff: JsonReader.optionalString(json, 'dropoff_text'),
      price: JsonReader.requireString(json, 'price'),
      createdAt: JsonReader.requireDateTime(json, 'created_at'),
      updatedAt: JsonReader.requireDateTime(json, 'updated_at'),
    );
  }

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
