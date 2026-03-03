abstract interface class SocketClient {
  /// Opens the socket connection (optionally with auth token).
  Future<void> connect({required String token});

  /// Closes the socket connection and releases resources.
  Future<void> disconnect();

  /// Emits an event with an optional payload.
  void emit(String event, Object? data);

  /// Listens to an event and exposes incoming payloads as a stream.
  Stream<Object?> on(String event);
}
