import 'package:taxi_driver_app/core/networking/api_client.dart';
import 'package:taxi_driver_app/features/home/data/models/complete_offer_response_model.dart';
import 'package:taxi_driver_app/features/home/data/models/current_and_pending_offer_model.dart';
import 'package:taxi_driver_app/features/home/data/models/offer_model.dart';

/// Remote contract for offer-related API calls.
abstract interface class OfferRemoteDataSource {
  Future<AcceptedOfferModel> acceptOffer({required String offerId});
  Future<void> declineOffer({required String offerId});
  Future<CurrentAndPendingOfferModel?> getCurrentAndPendingOffer();
  Future<CompleteOfferResponseModel> completeOffer({required String offerId});
}

/// HTTP implementation of [OfferRemoteDataSource].
final class OfferRemoteDataSourceImpl implements OfferRemoteDataSource {
  OfferRemoteDataSourceImpl({
    required this.apiClient,
  });

  final ApiClient apiClient;

  @override
  Future<AcceptedOfferModel> acceptOffer({required String offerId}) async {
    final data = await apiClient.postJson(
      '/api/admin/orders/accept',
      body: {'orderId': offerId},
    );

    return AcceptedOfferModel.fromJson(data);
  }

  @override
  Future<void> declineOffer({required String offerId}) async {
    await apiClient.postJson(
      '/api/admin/orders/decline',
      body: {'orderId': offerId},
    );
  }

  @override
  Future<CurrentAndPendingOfferModel?> getCurrentAndPendingOffer() async {
    final data = await apiClient.getJson('/api/admin/orders/current');
    return CurrentAndPendingOfferModel.fromJson(data);
  }

  @override
  Future<CompleteOfferResponseModel> completeOffer({
    required String offerId,
  }) async {
    final data = await apiClient.postJson('/api/admin/orders/$offerId/done');
    return CompleteOfferResponseModel.fromJson(data);
  }
}
