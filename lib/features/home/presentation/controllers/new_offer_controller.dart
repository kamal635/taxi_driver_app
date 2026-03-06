import 'dart:async' show StreamSubscription, unawaited;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/core/socket/socket_client_provider.dart';
import 'package:taxi_driver_app/features/home/domain/entities/offer_entity.dart';
import 'package:taxi_driver_app/features/home/presentation/providers/setup_providers.dart';

final newOfferControllerProvider =
    NotifierProvider<NewOfferController, NewOfferState>(
      NewOfferController.new,
    );

final class NewOfferController extends Notifier<NewOfferState> {
  StreamSubscription<NewOfferEntity>? _streamSubscription;

  @override
  NewOfferState build() {
    ref.onDispose(
      () {
        unawaited(_streamSubscription?.cancel());
        _streamSubscription = null;
      },
    );
    return NewOfferState(isLoading: false);
  }

  Future<void> start() async {
    if (_streamSubscription != null) return;
    state = state.copyWith(isLoading: true, error: null);

    try {
      await ref.read(socketConnectionManagerProvider).connectAndJoin();
      debugPrint('Socket Connection Manager success ');
    } on Exception catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
      debugPrint('Socket Connection Manager Erorr: $e');
      return;
    }

    final watchOffer = ref.read(watchNewOfferUsecaseProvider);

    _streamSubscription = watchOffer().listen(
      (newOfferEntity) {
        state = state.copyWith(
          currentOffer: newOfferEntity,
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
    state = state.copyWith(isLoading: false, error: null, currentOffer: null);

    debugPrint('Socket stop streaming');
  }

  void clearCurrent() {
    state = state.copyWith(currentOffer: null);
  }
}

final class NewOfferState {
  NewOfferState({
    required this.isLoading,
    this.currentOffer,
    this.error,
  });

  final NewOfferEntity? currentOffer;
  final bool isLoading;
  final String? error;

  static const Object _unset = Object();

  NewOfferState copyWith({
    Object? currentOffer = _unset,
    bool? isLoading,
    Object? error = _unset,
  }) {
    return NewOfferState(
      currentOffer: identical(currentOffer, _unset)
          ? this.currentOffer
          : currentOffer as NewOfferEntity?,
      isLoading: isLoading ?? this.isLoading,
      error: identical(error, _unset) ? this.error : error as String?,
    );
  }
}
