import 'package:bawabat_al_saeq/core/utils/json_reader.dart';
import 'package:bawabat_al_saeq/features/home/domain/entities/complete_offer_result_entity.dart';

/// Data model returned after completing an offer.
final class CompleteOfferResponseModel {
  const CompleteOfferResponseModel({
    required this.type,
    required this.message,
    required this.offerId,
  });

  factory CompleteOfferResponseModel.fromJson(Map<String, dynamic> json) {
    return CompleteOfferResponseModel(
      type: JsonReader.requireString(json, 'type'),
      message: JsonReader.requireString(json, 'message'),
      offerId: JsonReader.requireAnyString(json, const ['orderId', 'order_id']),
    );
  }

  final String type;
  final String message;
  final String offerId;

  CompleteOfferResultEntity toEntity() {
    return CompleteOfferResultEntity(
      type: type,
      message: message,
      offerId: offerId,
    );
  }
}
