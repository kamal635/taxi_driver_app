import 'package:taxi_driver_app/core/utils/json_reader.dart';
import 'package:taxi_driver_app/features/home/domain/entities/offer_entity.dart';

//-------------------------------------------
//    - Current And Pending Offer Model -
//-------------------------------------------
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

    final current = currentRaw as Map<String, dynamic>?;
    final pending = pendingRaw as Map<String, dynamic>?;

    return CurrentAndPendingOfferModel(
      currentOffer: current == null
          ? null
          : CurrentOfferModel.fromJson(current),
      pendingOffer: pending == null
          ? null
          : PendingOfferModel.fromJson(pending),
    );
  }

  final CurrentOfferModel? currentOffer;
  final PendingOfferModel? pendingOffer;
}

//-------------------------------------------
//        - Current Offer Model -
//-------------------------------------------
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

  /// Map "currentOrder" to the same domain entity used by the Accepted card.
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

//-------------------------------------------
//        - Pending Offer Model -
//-------------------------------------------
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

  /// Map "PendingOfferModel" to the same domain entity
  /// used by the NewOfferEntity.
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
