import 'package:taxi_driver_app/features/home/domain/entities/order_entity.dart';

sealed class OrderModel {
  OrderModel({
    required this.type,
    required this.orderId,
    required this.pickup,
    required this.price,
    this.dropoff,
  });

  final String type;
  final String orderId;
  final String pickup;
  final String? dropoff;
  final String price;
}

final class NewOrderModel extends OrderModel {
  NewOrderModel({
    required super.type,
    required super.orderId,
    required super.pickup,
    required super.price,
    super.dropoff,
  });

  factory NewOrderModel.fromJson(Map<String, dynamic> json) {
    return NewOrderModel(
      type: json['type'].toString(),
      orderId: json['orderId'].toString(),
      pickup: json['pickupText'].toString(),
      dropoff: json['dropoffText']?.toString(),
      price: json['price'].toString(),
    );
  }

  NewOrderEntity toEntity() {
    return NewOrderEntity(
      type: type,
      orderId: orderId,
      pickup: pickup,
      dropoff: dropoff,
      price: price,
    );
  }
}

final class OrderAcceptedModel extends OrderModel {
  OrderAcceptedModel({
    required super.type,
    required super.orderId,
    required super.pickup,
    required super.price,
    required this.customerPhone,
    super.dropoff,
    this.info,
  });

  final String customerPhone;
  final String? info;
}
