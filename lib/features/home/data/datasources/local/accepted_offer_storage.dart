import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:taxi_driver_app/features/home/domain/entities/offer_entity.dart';

final class AcceptedOfferStorage {
  AcceptedOfferStorage({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const _kAcceptedOfferJson = 'accepted_offer_json';

  Future<void> saveAccepted(OfferAcceptedEntity accepted) async {
    final json = jsonEncode({
      'type': accepted.type,
      'orderId': accepted.offerId,
      'pickupText': accepted.pickup,
      'dropoffText': accepted.dropoff,
      'price': accepted.price,
      'customerPhone': accepted.customerPhone,
      'note': accepted.notes,
    });

    await _storage.write(key: _kAcceptedOfferJson, value: json);
  }

  Future<OfferAcceptedEntity?> readAccepted() async {
    final raw = await _storage.read(key: _kAcceptedOfferJson);
    if (raw == null || raw.isEmpty) return null;

    final map = jsonDecode(raw);
    if (map is! Map<String, dynamic>) return null;

    return OfferAcceptedEntity(
      type: map['type']?.toString() ?? 'Accepted Offer',
      offerId: map['orderId']?.toString() ?? '',
      pickup: map['pickupText']?.toString() ?? '',
      dropoff: map['dropoffText']?.toString(),
      price: map['price']?.toString() ?? '',
      customerPhone: map['customerPhone']?.toString() ?? '',
      notes: map['note']?.toString(),
    );
  }

  Future<void> clear() async {
    await _storage.delete(key: _kAcceptedOfferJson);
  }
}
