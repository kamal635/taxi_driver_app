import 'package:taxi_driver_app/features/home/domain/entities/complete_order_result_entity.dart';
import 'package:taxi_driver_app/features/home/domain/repositories/offer_repo.dart';

final class CompleteOrderUseCase {
  CompleteOrderUseCase({required this.repo});

  final OfferRepository repo;

  Future<CompleteOrderResultEntity> call({required String orderId}) {
    return repo.completeOrder(orderId: orderId);
  }
}
