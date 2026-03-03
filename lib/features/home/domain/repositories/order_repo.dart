import 'package:taxi_driver_app/features/home/domain/entities/order_entity.dart';

abstract interface class OrderRepository {
  Stream<NewOrderEntity> watchOrder();
}
