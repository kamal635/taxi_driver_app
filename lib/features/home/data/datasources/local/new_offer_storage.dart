import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi_driver_app/features/home/domain/entities/offer_entity.dart';

final class NewOfferStorage {
  NewOfferStorage({Future<SharedPreferences>? prefs})
    : _prefs = prefs ?? SharedPreferences.getInstance();

  final Future<SharedPreferences> _prefs;

  static const _kNewOfferJson = 'new_offer_json';

  Future<void> save(NewOfferEntity offer) async {
    final prefs = await _prefs;

    final json = jsonEncode({
      'type': offer.type,
      'orderId': offer.offerId,
      'pickupText': offer.pickup,
      'dropoffText': offer.dropoff,
      'price': offer.price,
      // Store as UTC ms since epoch (stable + easy to compare)
      'expiresAtMs': offer.expiresAt.toUtc().millisecondsSinceEpoch,
    });

    await prefs.setString(_kNewOfferJson, json);
  }

  /// Returns the stored offer only if it is still valid (expiresAt > now).
  /// If expired, clears it and returns null.
  Future<NewOfferEntity?> readValid() async {
    final prefs = await _prefs;
    final raw = prefs.getString(_kNewOfferJson);

    if (raw == null || raw.isEmpty) return null;

    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) return null;

    final expiresAtMs = decoded['expiresAtMs'];
    final ms = (expiresAtMs is num)
        ? expiresAtMs.toInt()
        : int.tryParse('$expiresAtMs');
    if (ms == null) {
      await clear();
      return null;
    }

    final expiresAtUtc = DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true);
    if (!expiresAtUtc.isAfter(DateTime.now().toUtc())) {
      await clear();
      return null;
    }

    return NewOfferEntity(
      type: decoded['type']?.toString() ?? 'New Offer',
      offerId: decoded['orderId']?.toString() ?? '',
      pickup: decoded['pickupText']?.toString() ?? '',
      dropoff: decoded['dropoffText']?.toString(),
      price: decoded['price']?.toString() ?? '',
      expiresAt: expiresAtUtc.toLocal(),
    );
  }

  Future<void> clear() async {
    final prefs = await _prefs;
    await prefs.remove(_kNewOfferJson);
  }
}
