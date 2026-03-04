import 'package:taxi_driver_app/features/home/domain/entities/offer_entity.dart';

abstract interface class OfferRepository {
  Stream<NewOfferEntity> watchOffer();
  Future<OfferAcceptedEntity> accepteOfer({required String offeroId});
}
