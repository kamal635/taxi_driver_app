import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/core/socket/socket_client_provider.dart';
import 'package:taxi_driver_app/features/home/data/datasources/orders_socket_datasource.dart';
import 'package:taxi_driver_app/features/home/data/repositories/order_repository_impl.dart';
import 'package:taxi_driver_app/features/home/domain/repositories/order_repo.dart';
import 'package:taxi_driver_app/features/home/domain/usecases/watch_new_order_usecase.dart';

final ordersSocketDatasourceProvider = Provider<OrdersSocketDatasource>(
  (ref) {
    final socketClient = ref.read(socketClientProvider);
    return OrdersSocketDatasource(socketClient: socketClient);
  },
);

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  final ds = ref.read(ordersSocketDatasourceProvider);
  return OrderRepositoryImpl(ordersSocketDatasource: ds);
});

final watchNewOrderUsecaseProvider = Provider<WatchNewOrderUseCase>((ref) {
  final repo = ref.read(orderRepositoryProvider);
  return WatchNewOrderUseCase(orderRepository: repo);
});
