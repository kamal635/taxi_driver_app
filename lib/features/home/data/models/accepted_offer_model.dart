import 'package:bawabat_al_saeq/core/utils/json_reader.dart';
import 'package:bawabat_al_saeq/features/home/data/models/base_offer_model.dart';
import 'package:bawabat_al_saeq/features/home/data/models/offer_json_keys.dart';
import 'package:bawabat_al_saeq/features/home/domain/entities/offer_entity.dart';

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
      type: JsonReader.requireAnyString(json, OfferJsonKeys.type),
      offerId: JsonReader.requireAnyString(json, OfferJsonKeys.offerId),
      pickup: JsonReader.requireAnyString(json, OfferJsonKeys.pickup),
      dropoff: JsonReader.optionalAnyString(json, OfferJsonKeys.dropoff),
      notes: JsonReader.optionalAnyString(json, OfferJsonKeys.notes),
      price: JsonReader.requireAnyString(json, OfferJsonKeys.price),
      customerPhone: JsonReader.requireAnyString(
        json,
        OfferJsonKeys.customerPhone,
      ),
      cooldownUntil: JsonReader.requireAnyDateTime(
        json,
        OfferJsonKeys.cooldownUntil,
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
