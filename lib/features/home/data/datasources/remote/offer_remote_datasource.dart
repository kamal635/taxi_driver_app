import 'package:taxi_driver_app/core/networking/api_client.dart';
import 'package:taxi_driver_app/features/home/data/models/complete_offer_response_model.dart';
import 'package:taxi_driver_app/features/home/data/models/current_and_pending_offer_model.dart';
import 'package:taxi_driver_app/features/home/data/models/offer_model.dart';

abstract interface class OfferRemoteDatasource {
  Future<AccepteOfferdModel> accepteOffer({required String offerId});
  Future<void> declineOffer({required String offerId});
  Future<CurrentAndPendingOfferModel?> getCurrentAndPendingOffer();
  Future<CompleteOfferResponseModel> completeOffer({required String offerId});
}

final class OfferRemoteDatasourceImpl implements OfferRemoteDatasource {
  OfferRemoteDatasourceImpl({
    required this.apiClient,
  });

  final ApiClient apiClient;

  /// ========= 2- accepte offer
  @override
  Future<AccepteOfferdModel> accepteOffer({required String offerId}) async {
    final data = await apiClient.postJson(
      '/api/admin/orders/accept',
      body: {
        'orderId': offerId,
      },
    );

    return AccepteOfferdModel.fromJson(data);
  }

  /// ========= 3- decline Offer
  @override
  Future<void> declineOffer({required String offerId}) async {
    await apiClient.postJson(
      '/api/admin/orders/decline',
      body: {'orderId': offerId},
    );
  }

  /// ========= 4- get Current And Pending Offer
  @override
  Future<CurrentAndPendingOfferModel?> getCurrentAndPendingOffer() async {
    final data = await apiClient.getJson('/api/admin/orders/current');
    return CurrentAndPendingOfferModel.fromJson(data);
  }

  /// ========= 5- complete Offer
  @override
  Future<CompleteOfferResponseModel> completeOffer({
    required String offerId,
  }) async {
    final data = await apiClient.postJson('/api/admin/orders/$offerId/done');
    return CompleteOfferResponseModel.fromJson(data);
  }
}
