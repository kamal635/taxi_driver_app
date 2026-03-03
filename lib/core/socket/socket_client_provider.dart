import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/core/session/session_providers.dart';
import 'package:taxi_driver_app/core/socket/socket_client.dart';
import 'package:taxi_driver_app/core/socket/socket_io_client.dart';

final socketClientProvider = Provider<SocketClient>(
  (ref) {
    return SocketIoClient();
  },
);

final socketConnectionManagerProvider = Provider<Future<void>>((ref) async {
  final socketClient = ref.read(socketClientProvider);
  final authSession = ref.read(authSessionProvider);

  final token = authSession.token;
  final driverId = authSession.driverId;

  if (token == null || token.isEmpty || driverId == null || driverId.isEmpty) {
    throw StateError('Auth session is not ready (missing token/driverId).');
  }

  await socketClient.connect(token: token);

  // Join the driver room so the server can route offers to this driver.
  socketClient.emit('join_driver_room', driverId);
});
