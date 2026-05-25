import 'package:bawabat_al_saeq/features/home/domain/entities/complete_offer_result_entity.dart';
import 'package:bawabat_al_saeq/features/home/domain/entities/current_and_pending_offer_entity.dart';
import 'package:bawabat_al_saeq/features/home/domain/entities/offer_entity.dart';

abstract interface class OfferRepository {
  Future<OfferAcceptedEntity> acceptOffer({required String offerId});
  Future<void> declineOffer({required String offerId});
  Future<CurrentAndPendingOfferEntity?> getCurrentAndPendingOffer();
  Future<CompleteOfferResultEntity> completeOffer({required String offerId});
}
