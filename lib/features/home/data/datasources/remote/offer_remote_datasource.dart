import 'package:taxi_driver_app/core/networking/api_client.dart';
import 'package:taxi_driver_app/core/socket/socket_client.dart';
import 'package:taxi_driver_app/features/home/data/models/offer_model.dart';

abstract interface class OfferRemoteDatasource {
  Stream<NewOfferModel> watchOffer();
  Future<OfferAcceptedModel> accepteOffer({required String offeroId});
  Future<void> declineOffer({required String offeroId});
}

final class OfferRemoteDatasourceImpl implements OfferRemoteDatasource {
  OfferRemoteDatasourceImpl({
    required this.socketClient,
    required this.apiClient,
  });

  final ApiClient apiClient;
  final SocketClient socketClient;

  /// ========= 1- watch offer
  @override
  Stream<NewOfferModel> watchOffer() {
    return socketClient
        .on('order_update')
        // Keep only Map payloads
        .where((payload) => payload is Map)
        .cast<Map<dynamic, dynamic>>()
        .map((payload) {
          final json = Map<String, dynamic>.from(payload);
          return NewOfferModel.fromJson(json);
        });
  }

  /// ========= 2- accepte offer
  @override
  Future<OfferAcceptedModel> accepteOffer({required String offeroId}) async {
    final data = await apiClient.postJson(
      '/api/admin/orders/accept',
      body: {
        'orderId': offeroId,
      },
    );

    return OfferAcceptedModel.fromJson(data);
  }

  /// ========= 2- accepte offer
  @override
  Future<void> declineOffer({required String offeroId}) async {
    await apiClient.postJson(
      '/api/admin/orders/decline',
      body: {'orderId': offeroId},
    );
  }
}
