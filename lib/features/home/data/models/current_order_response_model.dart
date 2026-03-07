import 'package:taxi_driver_app/features/home/domain/entities/offer_entity.dart';

final class CurrentOrderResponseModel {
  const CurrentOrderResponseModel({required this.currentOrder});

  factory CurrentOrderResponseModel.fromJson(Map<String, dynamic> json) {
    final raw = json['currentOrder'];

    // Server explicitly returns null when there is no active order.
    if (raw == null) {
      return const CurrentOrderResponseModel(currentOrder: null);
    }

    if (raw is! Map<String, dynamic>) {
      throw const FormatException('Invalid currentOrder payload');
    }

    return CurrentOrderResponseModel(
      currentOrder: CurrentOrderModel.fromJson(raw),
    );
  }

  final CurrentOrderModel? currentOrder;
}

final class CurrentOrderModel {
  const CurrentOrderModel({
    required this.orderId,
    required this.customerPhone,
    required this.price,
    required this.orderStatus,
    required this.cooldownUntil,
  });

  factory CurrentOrderModel.fromJson(Map<String, dynamic> json) {
    final orderId = json['order_id']?.toString().trim();
    final customerPhone = json['customer_phone']?.toString().trim();
    final price = json['price']?.toString().trim();
    final orderStatus = json['order_status']?.toString().trim();

    final rawCooldown = json['cooldown_until'];
    if (rawCooldown == null) {
      throw const FormatException('Missing cooldown_until');
    }
    final cooldownUntil = DateTime.parse(rawCooldown.toString());

    if (orderId == null || orderId.isEmpty) {
      throw const FormatException('Missing order_id');
    }
    if (customerPhone == null || customerPhone.isEmpty) {
      throw const FormatException('Missing customer_phone');
    }
    if (price == null || price.isEmpty) {
      throw const FormatException('Missing price');
    }
    if (orderStatus == null || orderStatus.isEmpty) {
      throw const FormatException('Missing order_status');
    }

    return CurrentOrderModel(
      orderId: orderId,
      customerPhone: customerPhone,
      price: price,
      orderStatus: orderStatus,
      cooldownUntil: cooldownUntil,
    );
  }

  final String orderId;
  final String customerPhone;
  final String price;
  final String orderStatus;
  final DateTime cooldownUntil;

  /// Map "currentOrder" to the same domain entity used by the Accepted card.
  OfferAcceptedEntity toEntity() {
    return OfferAcceptedEntity(
      type: 'Accepted Offer', // UI badge title (or map from status if you want)
      offerId: orderId,
      pickup: '', // Not provided by /current (can show unknown in UI)
      price: price,
      customerPhone: customerPhone,
      cooldownUntil: cooldownUntil,
    );
  }
}
