import 'package:taxi_driver_app/features/home/domain/entities/complete_order_result_entity.dart';
import 'package:taxi_driver_app/features/home/domain/entities/current_and_pending_offer_entity.dart';
import 'package:taxi_driver_app/features/home/domain/entities/offer_entity.dart';

abstract interface class OfferRepository {
  Stream<NewOfferEntity> watchOffer();
  Future<OfferAcceptedEntity> accepteOfer({required String offeroId});
  Future<void> declineOffer({required String offeroId});
  Future<CurrentAndPendingOfferEntity?> getCurrentAndPendingOffer();
  Future<CompleteOrderResultEntity> completeOrder({required String orderId});
}
