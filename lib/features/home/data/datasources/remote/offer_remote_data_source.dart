import 'package:bawabat_al_saeq/core/networking/api_client.dart';
import 'package:bawabat_al_saeq/features/home/data/models/complete_offer_response_model.dart';
import 'package:bawabat_al_saeq/features/home/data/models/current_and_pending_offer_model.dart';
import 'package:bawabat_al_saeq/features/home/data/models/offer_model.dart';

/// Remote contract for offer-related API calls.
abstract interface class OfferRemoteDataSource {
  Future<AcceptedOfferModel> acceptOffer({required String offerId});
  Future<void> declineOffer({required String offerId});
  Future<CurrentAndPendingOfferModel?> getCurrentAndPendingOffer();
  Future<CompleteOfferResponseModel> completeOffer({required String offerId});
}

/// HTTP implementation of [OfferRemoteDataSource].
final class OfferRemoteDataSourceImpl implements OfferRemoteDataSource {
  OfferRemoteDataSourceImpl({required this.apiClient});

  final ApiClient apiClient;

  @override
  Future<AcceptedOfferModel> acceptOffer({required String offerId}) async {
    final data = await apiClient.postJson(
      _OfferApiPaths.accept,
      body: _orderBody(offerId),
    );

    return AcceptedOfferModel.fromJson(data);
  }

  @override
  Future<void> declineOffer({required String offerId}) async {
    await apiClient.postJson(
      _OfferApiPaths.decline,
      body: _orderBody(offerId),
    );
  }

  @override
  Future<CurrentAndPendingOfferModel?> getCurrentAndPendingOffer() async {
    final data = await apiClient.getJson(_OfferApiPaths.current);

    if (data.isEmpty) return null;

    return CurrentAndPendingOfferModel.fromJson(data);
  }

  @override
  Future<CompleteOfferResponseModel> completeOffer({
    required String offerId,
  }) async {
    final data = await apiClient.postJson(_OfferApiPaths.complete(offerId));
    return CompleteOfferResponseModel.fromJson(data);
  }

  Map<String, dynamic> _orderBody(String offerId) {
    return {'orderId': offerId};
  }
}

final class _OfferApiPaths {
  const _OfferApiPaths._();

  static const accept = '/api/admin/orders/accept';
  static const decline = '/api/admin/orders/decline';
  static const current = '/api/admin/orders/current';

  static String complete(String offerId) => '/api/admin/orders/$offerId/done';
}
