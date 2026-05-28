import 'package:bawabat_al_saeq/core/utils/json_reader.dart';
import 'package:bawabat_al_saeq/features/home/domain/entities/current_and_pending_offer_entity.dart';
import 'package:bawabat_al_saeq/features/home/domain/entities/offer_entity.dart';

/// Combined payload that may contain the active current offer and/or a pending
/// incoming offer.
final class CurrentAndPendingOfferModel {
  const CurrentAndPendingOfferModel({
    required this.currentOffer,
    required this.pendingOffer,
  });

  factory CurrentAndPendingOfferModel.fromJson(Map<String, dynamic> json) {
    final currentJson = JsonReader.optionalMap(json, 'currentOrder');
    final pendingJson = JsonReader.optionalMap(json, 'pendingOffer');

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
      offerId: JsonReader.requireAnyString(json, _CurrentOfferJsonKeys.offerId),
      customerPhone: JsonReader.requireAnyString(
        json,
        _CurrentOfferJsonKeys.customerPhone,
      ),
      pickup: JsonReader.requireAnyString(json, _CurrentOfferJsonKeys.pickup),
      dropoff: JsonReader.optionalAnyString(
        json,
        _CurrentOfferJsonKeys.dropoff,
      ),
      notes: JsonReader.optionalAnyString(json, _CurrentOfferJsonKeys.notes),
      price: JsonReader.requireAnyString(json, _CurrentOfferJsonKeys.price),
      type: JsonReader.requireAnyString(json, _CurrentOfferJsonKeys.type),
      cooldownUntil: JsonReader.requireAnyDateTime(
        json,
        _CurrentOfferJsonKeys.cooldownUntil,
      ),
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
      offerId: JsonReader.requireAnyString(json, _PendingOfferJsonKeys.offerId),
      pickup: JsonReader.requireAnyString(json, _PendingOfferJsonKeys.pickup),
      dropoff: JsonReader.optionalAnyString(
        json,
        _PendingOfferJsonKeys.dropoff,
      ),
      notes: JsonReader.optionalAnyString(json, _PendingOfferJsonKeys.notes),
      price: JsonReader.requireAnyString(json, _PendingOfferJsonKeys.price),
      type: JsonReader.requireAnyString(json, _PendingOfferJsonKeys.type),
      expiresAt: JsonReader.requireAnyDateTime(
        json,
        _PendingOfferJsonKeys.expiresAt,
      ),
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

final class _CurrentOfferJsonKeys {
  const _CurrentOfferJsonKeys._();

  static const offerId = ['order_id', 'orderId', 'id'];
  static const customerPhone = ['customer_phone', 'customerPhone', 'phone'];
  static const pickup = ['pickup_text', 'pickupText', 'pickup'];
  static const dropoff = ['dropoff_text', 'dropoffText', 'dropoff'];
  static const notes = ['note', 'notes'];
  static const price = ['price', 'fare', 'total'];
  static const type = ['order_status', 'type', 'status'];
  static const cooldownUntil = ['cooldown_until', 'cooldownUntil'];
}

final class _PendingOfferJsonKeys {
  const _PendingOfferJsonKeys._();

  static const offerId = ['order_id', 'orderId', 'id'];
  static const pickup = ['pickup_text', 'pickupText', 'pickup'];
  static const dropoff = ['dropoff_text', 'dropoffText', 'dropoff'];
  static const notes = ['note', 'notes'];
  static const price = ['price', 'fare', 'total'];
  static const type = ['order_status', 'type', 'status'];
  static const expiresAt = ['expires_at', 'expiresAt'];
}
