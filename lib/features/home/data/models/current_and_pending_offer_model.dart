import 'package:taxi_driver_app/core/utils/json_reader.dart';
import 'package:taxi_driver_app/features/home/domain/entities/current_and_pending_offer_entity.dart';
import 'package:taxi_driver_app/features/home/domain/entities/offer_entity.dart';

/// Combined payload that may contain the active current offer and/or a pending
/// incoming offer.
final class CurrentAndPendingOfferModel {
  const CurrentAndPendingOfferModel({
    required this.currentOffer,
    required this.pendingOffer,
  });

  factory CurrentAndPendingOfferModel.fromJson(Map<String, dynamic> json) {
    final currentRaw = json['currentOrder'];
    final pendingRaw = json['pendingOffer'];

    if (currentRaw != null && currentRaw is! Map<String, dynamic>) {
      throw const FormatException('Invalid currentOrder');
    }

    if (pendingRaw != null && pendingRaw is! Map<String, dynamic>) {
      throw const FormatException('Invalid pendingOffer');
    }

    final currentJson = currentRaw as Map<String, dynamic>?;
    final pendingJson = pendingRaw as Map<String, dynamic>?;

    return CurrentAndPendingOfferModel(
      currentOffer: currentJson == null
          ? null
          : CurrentOfferModel.fromJson(currentJson),
      pendingOffer: pendingJson == null
          ? null
          : PendingOfferModel.fromJson(pendingJson),
    );
  }

  final CurrentOfferModel? currentOffer;
  final PendingOfferModel? pendingOffer;

  CurrentAndPendingOfferEntity toEntity() {
    return CurrentAndPendingOfferEntity(
      currentOffer: currentOffer?.toEntity(),
      pendingOffer: pendingOffer?.toEntity(),
    );
  }
}

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
      offerId: JsonReader.requireString(json, 'order_id'),
      customerPhone: JsonReader.requireString(json, 'customer_phone'),
      pickup: JsonReader.requireString(json, 'pickup_text'),
      dropoff: JsonReader.optionalString(json, 'dropoff_text'),
      notes: JsonReader.optionalString(json, 'note'),
      price: JsonReader.requireString(json, 'price'),
      type: JsonReader.requireString(json, 'order_status'),
      cooldownUntil: JsonReader.requireDateTime(json, 'cooldown_until'),
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

/// Data model for an incoming pending offer.
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
      offerId: JsonReader.requireString(json, 'order_id'),
      pickup: JsonReader.requireString(json, 'pickup_text'),
      dropoff: JsonReader.optionalString(json, 'dropoff_text'),
      notes: JsonReader.optionalString(json, 'note'),
      price: JsonReader.requireString(json, 'price'),
      type: JsonReader.requireString(json, 'order_status'),
      expiresAt: JsonReader.requireDateTime(json, 'expires_at'),
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
