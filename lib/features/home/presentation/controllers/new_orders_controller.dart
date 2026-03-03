import 'dart:async' show StreamSubscription, unawaited;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/core/socket/socket_client_provider.dart';
import 'package:taxi_driver_app/features/home/domain/entities/order_entity.dart';
import 'package:taxi_driver_app/features/home/presentation/providers/setup_providers.dart';

final newOrdersControllerProvider =
    NotifierProvider<NewOrdersController, NewOrderState>(
      NewOrdersController.new,
    );

final class NewOrdersController extends Notifier<NewOrderState> {
  StreamSubscription<NewOrderEntity>? _streamSubscription;

  @override
  NewOrderState build() {
    ref.onDispose(
      () {
        unawaited(_streamSubscription?.cancel());
        _streamSubscription = null;
      },
    );
    return NewOrderState(isLoading: false);
  }

  Future<void> start() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      await ref.read(socketConnectionManagerProvider);
    } on Exception catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
      debugPrint('Socket Connection Manager Erorr: $e');
      return;
    }

    final watchOrder = ref.read(watchNewOrderUsecaseProvider);

    if (_streamSubscription != null) return;

    _streamSubscription = watchOrder().listen(
      (newOrderEntity) {
        state = state.copyWith(
          currentOrder: newOrderEntity,
          isLoading: false,
          error: null,
        );
      },
      onError: (Object err, StackTrace st) {
        state = state.copyWith(
          error: err.toString(),
          isLoading: false,
        );

        debugPrint('Socket Streaming Controller Erorr: $err');
      },
    );

    debugPrint('Socket start streaming');
  }

  Future<void> stop() async {
    // Cancel stream subscription
    await _streamSubscription?.cancel();
    _streamSubscription = null;

    // Disconnect socket (optional but recommended)
    await ref.read(socketClientProvider).disconnect();

    // Reset UI state
    state = state.copyWith(
      isLoading: false,
      error: null,
    );

    debugPrint('Socket stop streaming');
  }
}

final class NewOrderState {
  NewOrderState({
    required this.isLoading,
    this.currentOrder,
    this.error,
  });

  final NewOrderEntity? currentOrder;
  final bool isLoading;
  final String? error;

  static const Object _unset = Object();

  NewOrderState copyWith({
    NewOrderEntity? currentOrder,
    bool? isLoading,
    Object? error = _unset,
  }) {
    return NewOrderState(
      currentOrder: currentOrder ?? this.currentOrder,
      isLoading: isLoading ?? this.isLoading,
      error: identical(error, _unset) ? this.error : error as String?,
    );
  }
}
