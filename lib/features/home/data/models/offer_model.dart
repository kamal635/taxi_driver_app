import 'package:taxi_driver_app/features/home/domain/entities/offer_entity.dart';

sealed class OfferModel {
  OfferModel({
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
  NewOfferModel({
    required super.type,
    required super.offerId,
    required super.pickup,
    required super.price,
    super.dropoff,
  });

  factory NewOfferModel.fromJson(Map<String, dynamic> json) {
    return NewOfferModel(
      type: json['type'].toString(),
      offerId: json['orderId'].toString(),
      pickup: json['pickupText'].toString(),
      dropoff: json['dropoffText']?.toString(),
      price: json['price'].toString(),
    );
  }

  NewOfferEntity toEntity() {
    return NewOfferEntity(
      type: type,
      offerId: offerId,
      pickup: pickup,
      dropoff: dropoff,
      price: price,
    );
  }
}

final class OfferAcceptedModel extends OfferModel {
  OfferAcceptedModel({
    required super.type,
    required super.offerId,
    required super.pickup,
    required super.price,
    required this.customerPhone,
    super.dropoff,
    this.note,
  });

  factory OfferAcceptedModel.fromJson(Map<String, dynamic> json) {
    return OfferAcceptedModel(
      type: json['type'].toString(),
      offerId: json['orderId'].toString(),
      pickup: json['pickupText'].toString(),
      dropoff: json['dropoffText']?.toString(),
      price: json['price'].toString(),
      customerPhone: json['customerPhone'].toString(),
      note: json['note']?.toString(),
    );
  }

  final String customerPhone;
  final String? note;

  OfferAcceptedEntity toEntity() {
    return OfferAcceptedEntity(
      type: type,
      offerId: offerId,
      pickup: pickup,
      dropoff: dropoff,
      price: price,
      customerPhone: customerPhone,
      notes: note,
    );
  }
}
