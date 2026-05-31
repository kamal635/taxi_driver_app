import 'package:bawabat_al_saeq/core/utils/json_reader.dart';
import 'package:bawabat_al_saeq/features/home/data/models/offer_json_keys.dart';
import 'package:bawabat_al_saeq/features/home/domain/entities/offer_entity.dart';

/// Data model for an incoming pending offer restored from backend.
final class PendingOfferModel {
  const PendingOfferModel({
    required this.offerId,
    required this.price,
    required this.pickup,
    required this.type,
    required this.expiresAt,
    this.notes,
    this.dropoff,
  });

  factory PendingOfferModel.fromJson(Map<String, dynamic> json) {
    return PendingOfferModel(
      offerId: JsonReader.requireAnyString(json, OfferJsonKeys.offerId),
      pickup: JsonReader.requireAnyString(json, OfferJsonKeys.pickup),
      dropoff: JsonReader.optionalAnyString(json, OfferJsonKeys.dropoff),
      notes: JsonReader.optionalAnyString(json, OfferJsonKeys.notes),
      price: JsonReader.requireAnyString(json, OfferJsonKeys.price),
      type: JsonReader.requireAnyString(json, OfferJsonKeys.type),
      expiresAt: JsonReader.requireAnyDateTime(json, OfferJsonKeys.expiresAt),
    );
  }

  final String offerId;
  final String pickup;
  final String? dropoff;
  final String? notes;
  final String price;
  final String type;
  final DateTime expiresAt;

  NewOfferEntity toEntity() {
    return NewOfferEntity(
      offerId: offerId,
      pickup: pickup,
      dropoff: dropoff,
      notes: notes,
      price: price,
      type: type,
      expiresAt: expiresAt,
    );
  }
}
