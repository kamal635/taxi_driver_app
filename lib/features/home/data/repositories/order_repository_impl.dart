import 'package:taxi_driver_app/features/home/data/datasources/orders_socket_datasource.dart';
import 'package:taxi_driver_app/features/home/domain/entities/order_entity.dart';
import 'package:taxi_driver_app/features/home/domain/repositories/order_repo.dart';

final class OrderRepositoryImpl implements OrderRepository {
  OrderRepositoryImpl({required this.ordersSocketDatasource});

  final OrdersSocketDatasource ordersSocketDatasource;
  @override
  Stream<NewOrderEntity> watchOrder() {
    return ordersSocketDatasource.watchOrder().map((m) => m.toEntity());
  }
}
