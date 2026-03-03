import 'dart:async';

import 'package:socket_io_client/socket_io_client.dart' as sio;
import 'package:taxi_driver_app/core/socket/socket_client.dart';

final class SocketIoClient implements SocketClient {
  SocketIoClient();

  sio.Socket? _socket;

  bool get isConnected => _socket?.connected ?? false;
  final String _baseUrl = 'http://10.0.2.2:3000';

  /// ---------- 1- connect -------------
  @override
  Future<void> connect({required String token}) async {
    if (isConnected) return;

    _socket = sio.io(
      _baseUrl,
      <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
        'auth': {'token': token},
      },
    );
    final completer = Completer<void>();

    // Complete when connected
    _socket!.onConnect((_) {
      if (!completer.isCompleted) completer.complete();
    });

    // Complete with error on connect failure
    _socket!.onConnectError((err) {
      if (!completer.isCompleted) {
        completer.completeError(
          Exception(err?.toString() ?? 'connect_error'),
        );
      }
    });

    _socket!.connect();

    // Wait until connected (or failed)
    await completer.future;
  }

  /// ---------- 2- disconnect  -------------
  @override
  Future<void> disconnect() async {
    if (_socket == null) return;

    _socket!.disconnect();
    _socket!.clearListeners();
    _socket!.dispose();

    _socket = null;
  }

  /// ---------- 3- emit  -------------
  @override
  void emit(String event, Object? data) {
    if (_socket == null || !isConnected) return;

    _socket!.emit(event, data);
  }

  /// ---------- 4- on  -------------
  @override
  Stream<Object?> on(String event) {
    final socket = _socket;

    // If there's no socket instance yet, return an empty stream.
    if (socket == null) {
      return const Stream<Object?>.empty();
    }

    final controller = StreamController<Object?>.broadcast();

    void handler(dynamic data) {
      if (!controller.isClosed) {
        controller.add(data);
      }
    }

    // Attach the socket listener when the first subscriber listens.
    controller
      ..onListen = () {
        socket.on(event, handler);
      }
      // Detach the socket listener and close the controller
      // when the last subscriber cancels.
      ..onCancel = () async {
        socket.off(event, handler);
        await controller.close();
      };

    return controller.stream;
  }
}
