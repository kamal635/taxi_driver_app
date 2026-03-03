import 'package:taxi_driver_app/core/socket/socket_client.dart';
import 'package:taxi_driver_app/features/home/data/models/order_model.dart';

final class OrdersSocketDatasource {
  OrdersSocketDatasource({required this.socketClient});

  final SocketClient socketClient;

  Stream<NewOrderModel> watchOrder() {
    return socketClient
        .on('order_update')
        // Keep only Map payloads
        .where((payload) => payload is Map)
        .cast<Map<dynamic, dynamic>>()
        .map((payload) {
          final json = Map<String, dynamic>.from(payload);
          return NewOrderModel.fromJson(json);
        });
  }
}
