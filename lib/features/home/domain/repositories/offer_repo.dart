import 'package:taxi_driver_app/features/home/domain/entities/complete_order_result_entity.dart';
import 'package:taxi_driver_app/features/home/domain/entities/offer_entity.dart';

abstract interface class OfferRepository {
  Stream<NewOfferEntity> watchOffer();
  Future<OfferAcceptedEntity> accepteOfer({required String offeroId});
  Future<void> declineOffer({required String offeroId});
  Future<OfferAcceptedEntity?> getCurrentOrder();
  Future<CompleteOrderResultEntity> completeOrder({required String orderId});
}
