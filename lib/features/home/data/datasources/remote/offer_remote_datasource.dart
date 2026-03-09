import 'package:taxi_driver_app/core/networking/api_client.dart';
import 'package:taxi_driver_app/core/socket/socket_client.dart';
import 'package:taxi_driver_app/features/home/data/models/complete_order_response_model.dart';
import 'package:taxi_driver_app/features/home/data/models/current_and_pending_offer_model.dart';
import 'package:taxi_driver_app/features/home/data/models/offer_model.dart';

abstract interface class OfferRemoteDatasource {
  Stream<NewOfferModel> watchOffer();
  Future<AccepteOfferdModel> accepteOffer({required String offeroId});
  Future<void> declineOffer({required String offeroId});
  Future<CurrentAndPendingOfferModel?> getCurrentAndPendingOffer();
  Future<CompleteOrderResponseModel> completeOrder({required String orderId});
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
        .on('new_offer')
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
  Future<AccepteOfferdModel> accepteOffer({required String offeroId}) async {
    final data = await apiClient.postJson(
      '/api/admin/orders/accept',
      body: {
        'orderId': offeroId,
      },
    );

    return AccepteOfferdModel.fromJson(data);
  }

  /// ========= 2- accepte offer
  @override
  Future<void> declineOffer({required String offeroId}) async {
    await apiClient.postJson(
      '/api/admin/orders/decline',
      body: {'orderId': offeroId},
    );
  }

  @override
  Future<CurrentAndPendingOfferModel?> getCurrentAndPendingOffer() async {
    final data = await apiClient.getJson('/api/admin/orders/current');
    return CurrentAndPendingOfferModel.fromJson(data);
  }

  @override
  Future<CompleteOrderResponseModel> completeOrder({
    required String orderId,
  }) async {
    final data = await apiClient.postJson('/api/admin/orders/$orderId/done');
    return CompleteOrderResponseModel.fromJson(data);
  }
}
