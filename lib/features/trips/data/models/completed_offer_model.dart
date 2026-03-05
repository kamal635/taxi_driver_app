import 'package:taxi_driver_app/features/trips/domain/entities/completed_offer_entity.dart';

final class CompletedOfferModel {
  CompletedOfferModel({
    required this.offerId,
    required this.pickup,
    required this.dropoff,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CompletedOfferModel.fromJson(Map<String, dynamic> json) {
    return CompletedOfferModel(
      offerId: json['id'].toString(),
      pickup: json['pickup_text'].toString(),
      dropoff: json['dropoff_text'].toString(),
      price: json['price'].toString(),
      createdAt: DateTime.parse(json['created_at'].toString()),
      updatedAt: DateTime.parse(json['updated_at'].toString()),
    );
  }

  final String offerId;
  final String pickup;
  final String dropoff;
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
