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

    final json = _normalizedOfferJson(Map<String, dynamic>.from(decoded));
    return NewOfferModel.fromJson(json).toEntity();
  }

  Map<String, dynamic> _normalizedOfferJson(Map<String, dynamic> json) {
    final merged = Map<String, dynamic>.from(json);

    for (final key in _nestedOfferPayloadKeys) {
      final nested = json[key];
      if (nested is! Map) continue;

      final nestedJson = Map<String, dynamic>.from(nested);
      for (final entry in nestedJson.entries) {
        merged.putIfAbsent(entry.key, () => entry.value);
      }
    }

    return merged;
  }
}

const _nestedOfferPayloadKeys = [
  'offer',
  'order',
  'data',
  'payload',
  'pendingOffer',
  'pending_offer',
];
