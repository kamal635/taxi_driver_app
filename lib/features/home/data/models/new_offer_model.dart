import 'package:bawabat_al_saeq/core/utils/json_reader.dart';
import 'package:bawabat_al_saeq/features/home/data/models/base_offer_model.dart';
import 'package:bawabat_al_saeq/features/home/data/models/offer_json_keys.dart';
import 'package:bawabat_al_saeq/features/home/domain/entities/offer_entity.dart';

/// Data model for a newly received pending offer.
final class NewOfferModel extends OfferModel {
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
      type: JsonReader.requireAnyString(json, OfferJsonKeys.type),
      offerId: JsonReader.requireAnyString(json, OfferJsonKeys.offerId),
      pickup: JsonReader.requireAnyString(json, OfferJsonKeys.pickup),
      dropoff: JsonReader.optionalAnyString(json, OfferJsonKeys.dropoff),
      notes: JsonReader.optionalAnyString(json, OfferJsonKeys.notes),
      price: JsonReader.requireAnyString(json, OfferJsonKeys.price),
      expiresAt: JsonReader.requireAnyDateTime(json, OfferJsonKeys.expiresAt),
    );
  }

  final DateTime expiresAt;

  NewOfferEntity toEntity() {
    return NewOfferEntity(
      type: type,
      offerId: offerId,
      pickup: pickup,
      dropoff: dropoff,
      price: price,
      expiresAt: expiresAt,
      notes: notes,
    );
  }
}
