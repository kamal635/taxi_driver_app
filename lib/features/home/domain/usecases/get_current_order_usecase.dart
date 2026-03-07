import 'package:taxi_driver_app/features/home/domain/entities/offer_entity.dart';
import 'package:taxi_driver_app/features/home/domain/repositories/offer_repo.dart';

final class GetCurrentOrderUseCase {
  GetCurrentOrderUseCase({required this.repo});

  final OfferRepository repo;

  Future<OfferAcceptedEntity?> call() {
    return repo.getCurrentOrder();
  }
}
