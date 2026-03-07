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
  StreamSubscription<NewOfferEntity>? _streamSub;

  @override
  NewOfferState build() {
    // Clean up subscription when provider is disposed.
    ref.onDispose(() {
      unawaited(_streamSub?.cancel());
      _streamSub = null;
    });

    // Hydrate from local storage (if still valid).
    unawaited(_hydrateFromStorage());

    return NewOfferState(isLoading: false);
  }

  /// Load the last stored offer (only if it is still valid / not expired).
  Future<void> _hydrateFromStorage() async {
    try {
      final stored = await ref.read(newOfferStorageProvider).readValid();
      if (stored == null) return;

      // Avoid overwriting a currently displayed offer.
      if (state.currentOffer == null) {
        state = state.copyWith(currentOffer: stored);
      }
    } on Exception catch (e) {
      debugPrint('NewOffer hydrate failed: $e');
    }
  }

  /// Start socket connection + subscribe to new offers.
  Future<void> start() async {
    // Guard: don't create multiple subscriptions.
    if (_streamSub != null) return;

    state = state.copyWith(isLoading: true, error: null);

    // Ensure socket is connected and room is joined.
    try {
      await ref.read(socketConnectionManagerProvider).connectAndJoin();
      debugPrint('Socket Connection Manager success');
    } on Exception catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      debugPrint('Socket Connection Manager Error: $e');
      return;
    }

    final watchOffer = ref.read(watchNewOfferUsecaseProvider);

    // Subscribe to offer stream.
    _streamSub = watchOffer().listen(
      (offer) {
        // Update UI state.
        state = state.copyWith(
          currentOffer: offer,
          isLoading: false,
          error: null,
        );

        // Persist offer locally (best-effort).
        unawaited(ref.read(newOfferStorageProvider).save(offer));
      },
      onError: (Object err, StackTrace st) {
        // Surface stream errors to the UI.
        state = state.copyWith(isLoading: false, error: err.toString());
        debugPrint('Socket Streaming Error: $err');
      },
    );

    debugPrint('Socket start streaming');
  }

  /// Stop listening to offers and disconnect socket.
  Future<void> stop() async {
    await _streamSub?.cancel();
    _streamSub = null;

    // Disconnect socket (best-effort).
    await ref.read(socketClientProvider).disconnect();

    // Keep currentOffer as-is; stop just turns off streaming.
    state = state.copyWith(isLoading: false, error: null);

    debugPrint('Socket stop streaming');
  }

  /// Clear current offer from UI and local storage.
  Future<void> clearCurrent() async {
    await ref.read(newOfferStorageProvider).clear();
    state = state.copyWith(currentOffer: null);
  }
}

final class NewOfferState {
  NewOfferState({
    required this.isLoading,
    this.currentOffer,
    this.error,
  });

  final bool isLoading;
  final NewOfferEntity? currentOffer;
  final String? error;

  // Sentinel to support explicit null (clear currentOffer / error).
  static const Object _unset = Object();

  NewOfferState copyWith({
    Object? currentOffer = _unset,
    bool? isLoading,
    Object? error = _unset,
  }) {
    return NewOfferState(
      isLoading: isLoading ?? this.isLoading,
      currentOffer: identical(currentOffer, _unset)
          ? this.currentOffer
          : currentOffer as NewOfferEntity?,
      error: identical(error, _unset) ? this.error : error as String?,
    );
  }
}
