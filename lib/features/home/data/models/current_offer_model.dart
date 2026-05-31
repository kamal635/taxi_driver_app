import 'package:bawabat_al_saeq/core/utils/json_reader.dart';
import 'package:bawabat_al_saeq/features/home/data/models/offer_json_keys.dart';
import 'package:bawabat_al_saeq/features/home/domain/entities/offer_entity.dart';

/// Data model for the currently accepted offer.
final class CurrentOfferModel {
  const CurrentOfferModel({
    required this.offerId,
    required this.customerPhone,
    required this.price,
    required this.pickup,
    required this.type,
    required this.cooldownUntil,
    this.notes,
    this.dropoff,
  });

  factory CurrentOfferModel.fromJson(Map<String, dynamic> json) {
    return CurrentOfferModel(
      offerId: JsonReader.requireAnyString(json, OfferJsonKeys.offerId),
      customerPhone: JsonReader.requireAnyString(
        json,
        OfferJsonKeys.customerPhone,
      ),
      pickup: JsonReader.requireAnyString(json, OfferJsonKeys.pickup),
      dropoff: JsonReader.optionalAnyString(json, OfferJsonKeys.dropoff),
      notes: JsonReader.optionalAnyString(json, OfferJsonKeys.notes),
      price: JsonReader.requireAnyString(json, OfferJsonKeys.price),
      type: JsonReader.requireAnyString(json, OfferJsonKeys.type),
      cooldownUntil: JsonReader.requireAnyDateTime(
        json,
        OfferJsonKeys.cooldownUntil,
      ),
    );
  }

  final String offerId;
  final String customerPhone;
  final String pickup;
  final String? dropoff;
  final String? notes;
  final String price;
  final String type;
  final DateTime cooldownUntil;

  OfferAcceptedEntity toEntity() {
    return OfferAcceptedEntity(
      offerId: offerId,
      customerPhone: customerPhone,
      pickup: pickup,
      dropoff: dropoff,
      notes: notes,
      price: price,
      type: type,
      cooldownUntil: cooldownUntil,
    );
  }
}
