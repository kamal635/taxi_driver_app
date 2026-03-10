import 'dart:async' show FutureOr, StreamSubscription, unawaited;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/core/socket/socket_client_provider.dart';
import 'package:taxi_driver_app/features/home/domain/entities/offer_entity.dart';
import 'package:taxi_driver_app/features/home/presentation/providers/setup_providers.dart';

//-------------------------------------------
//       - New Offer Controller Provider -
//-------------------------------------------

final newOfferControllerProvider =
    AsyncNotifierProvider<NewOfferController, NewOfferState>(
      NewOfferController.new,
    );

//-------------------------------------------
//            - New Offer Controller -
//-------------------------------------------

final class NewOfferController extends AsyncNotifier<NewOfferState> {
  StreamSubscription<NewOfferEntity>? _streamSub;

  @override
  FutureOr<NewOfferState> build() async {
    ref.onDispose(() {
      unawaited(_streamSub?.cancel());
      _streamSub = null;
    });

    final result = await ref.watch(currentAndPendingOfferProvider.future);
    final pendingOffer = result?.pendingOffer;

    return NewOfferState(currentOffer: pendingOffer);
  }

  NewOfferState get _currentState =>
      state.asData?.value ?? const NewOfferState();

  Future<void> start() async {
    if (_streamSub != null) return;

    state = AsyncData(
      _currentState.copyWith(
        isConnecting: true,
        errorMessage: null,
      ),
    );

    try {
      await ref.read(socketConnectionManagerProvider).connectAndJoin();
      debugPrint('Socket Connection Manager success');
    } on Exception catch (e) {
      state = AsyncData(
        _currentState.copyWith(
          isConnecting: false,
          errorMessage: e.toString(),
        ),
      );
      debugPrint('Socket Connection Manager Error: $e');
      return;
    }

    final watchOffer = ref.read(watchNewOfferUsecaseProvider);

    state = AsyncData(
      _currentState.copyWith(
        isConnecting: false,
        errorMessage: null,
      ),
    );

    _streamSub = watchOffer().listen(
      (offer) {
        state = AsyncData(
          _currentState.copyWith(
            currentOffer: offer,
            isConnecting: false,
            errorMessage: null,
          ),
        );
      },
      onError: (Object err, StackTrace st) {
        state = AsyncData(
          _currentState.copyWith(
            isConnecting: false,
            errorMessage: err.toString(),
          ),
        );
        debugPrint('Socket Streaming Error: $err');
      },
    );

    debugPrint('Socket start streaming');
  }

  Future<void> stop() async {
    await _streamSub?.cancel();
    _streamSub = null;

    await ref.read(socketClientProvider).disconnect();

    state = AsyncData(
      _currentState.copyWith(
        isConnecting: false,
        errorMessage: null,
      ),
    );

    debugPrint('Socket stop streaming');
  }

  void clearCurrent() {
    state = AsyncData(
      _currentState.copyWith(currentOffer: null),
    );
  }

  void clearError() {
    state = AsyncData(
      _currentState.copyWith(errorMessage: null),
    );
  }
}

//-------------------------------------------
//              - New Offer State -
//-------------------------------------------

@immutable
final class NewOfferState {
  const NewOfferState({
    this.currentOffer,
    this.isConnecting = false,
    this.errorMessage,
  });

  final NewOfferEntity? currentOffer;
  final bool isConnecting;
  final String? errorMessage;

  static const Object _unset = Object();

  NewOfferState copyWith({
    Object? currentOffer = _unset,
    bool? isConnecting,
    Object? errorMessage = _unset,
  }) {
    return NewOfferState(
      currentOffer: identical(currentOffer, _unset)
          ? this.currentOffer
          : currentOffer as NewOfferEntity?,
      isConnecting: isConnecting ?? this.isConnecting,
      errorMessage: identical(errorMessage, _unset)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }
}
