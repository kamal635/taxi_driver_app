sealed class OrderEntity {
  OrderEntity({
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

final class NewOrderEntity extends OrderEntity {
  NewOrderEntity({
    required super.type,
    required super.orderId,
    required super.pickup,
    required super.price,
    super.dropoff,
  });
}

final class OrderAcceptedEntity extends OrderEntity {
  OrderAcceptedEntity({
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
