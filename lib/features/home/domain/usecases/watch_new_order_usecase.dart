import 'package:taxi_driver_app/features/home/domain/entities/order_entity.dart';
import 'package:taxi_driver_app/features/home/domain/repositories/order_repo.dart';

final class WatchNewOrderUseCase {
  WatchNewOrderUseCase({required this.orderRepository});

  final OrderRepository orderRepository;

  Stream<NewOrderEntity> call() {
    return orderRepository.watchOrder();
  }
}
