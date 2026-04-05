import 'package:taxi_driver_app/features/home/domain/entities/offer_entity.dart';

/// Base structure shared by parsed offer models.
sealed class OfferModel {
  const OfferModel({
    required this.type,
    required this.offerId,
    required this.pickup,
    required this.price,
    this.dropoff,
    this.notes,
  });

  final String type;
  final String offerId;
  final String pickup;
  final String? dropoff;
  final String? notes;
  final String price;
}

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
    String requireString(List<String> keys) {
      for (final key in keys) {
        final value = json[key];
        final text = value?.toString().trim();

        if (text != null && text.isNotEmpty) {
          return text;
        }
      }

      throw FormatException('Missing required field: ${keys.join(" / ")}');
    }

    String? optionalString(List<String> keys) {
      for (final key in keys) {
        final value = json[key];
        final text = value?.toString().trim();

        if (text != null && text.isNotEmpty) {
          return text;
        }
      }

      return null;
    }

    DateTime requireDateTime(List<String> keys) {
      final raw = requireString(keys);
      final parsed = DateTime.tryParse(raw);

      if (parsed == null) {
        throw FormatException(
          'Invalid date field: ${keys.join(" / ")} -> $raw',
        );
      }

      return parsed;
    }

    return NewOfferModel(
      type: requireString(['type', 'order_status']),
      offerId: requireString(['orderId', 'offerId', 'id', 'order_id']),
      pickup: requireString([
        'pickupText',
        'pickup',
        'pickup_address',
        'pickup_text',
      ]),
      dropoff: optionalString([
        'dropoffText',
        'dropoff',
        'dropoff_address',
        'dropoff_text',
      ]),
      price: requireString(['price']),
      expiresAt: requireDateTime(['expiresAt', 'expires_at']),
      notes: optionalString(['note', 'notes']),
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
    String requireString(String key) {
      final value = json[key]?.toString().trim();
      if (value == null || value.isEmpty) {
        throw FormatException('Missing required field: $key');
      }
      return value;
    }

    String? optionalString(String key) {
      final value = json[key]?.toString().trim();
      return value == null || value.isEmpty ? null : value;
    }

    final cooldownRaw = requireString('cooldownUntil');
    final cooldownUntil = DateTime.tryParse(cooldownRaw);

    if (cooldownUntil == null) {
      throw FormatException(
        'Invalid date field: cooldownUntil -> $cooldownRaw',
      );
    }

    return AcceptedOfferModel(
      type: requireString('type'),
      offerId: requireString('orderId'),
      pickup: requireString('pickupText'),
      dropoff: optionalString('dropoffText'),
      price: requireString('price'),
      customerPhone: requireString('customerPhone'),
      notes: optionalString('note'),
      cooldownUntil: cooldownUntil,
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
