import 'dart:convert';

import 'package:bawabat_al_saeq/features/home/data/models/new_offer_model.dart';
import 'package:bawabat_al_saeq/features/home/domain/entities/offer_entity.dart';

final class NewOfferPayloadParser {
  const NewOfferPayloadParser();

  NewOfferEntity parse(String payloadJson) {
    final decoded = jsonDecode(payloadJson);

    if (decoded is! Map) {
      throw const FormatException('Offer payload is not a JSON object.');
    }

    final json = Map<String, dynamic>.from(decoded);
    return NewOfferModel.fromJson(json).toEntity();
  }
}
