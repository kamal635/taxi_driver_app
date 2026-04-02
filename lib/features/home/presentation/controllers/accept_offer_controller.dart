import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/core/errors/failure.dart';
import 'package:taxi_driver_app/features/availability/presentation/controllers/availability_controller.dart';
import 'package:taxi_driver_app/features/home/domain/entities/offer_entity.dart';
import 'package:taxi_driver_app/features/home/domain/usecases/accepte_offer.dart';
import 'package:taxi_driver_app/features/home/presentation/controllers/new_offer_controller.dart';
import 'package:taxi_driver_app/features/home/presentation/providers/setup_providers.dart';

// Provides the accepted offer controller.
final accepteOfferControllerProvider =
    AsyncNotifierProvider<AccepteOfferController, AccepteOfferState>(
      AccepteOfferController.new,
    );

final class AccepteOfferController extends AsyncNotifier<AccepteOfferState> {
  late final AcceptOfferUseCase _accepteOfferUsecase;

  bool _isSyncingFromBackend = false;

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  FutureOr<AccepteOfferState> build() async {
    _accepteOfferUsecase = ref.read(accepteOfferUsecaseProvider);

    final result = await ref.read(currentAndPendingOfferProvider.future);
    final currentOffer = result?.currentOffer;

    return AccepteOfferState(
      offerAcceptedEntity: currentOffer,
      doneEndsAt: currentOffer?.cooldownUntil,
    );
  }

  // ---------------------------------------------------------------------------
  // Accept
  // ---------------------------------------------------------------------------

  // Accept the current pending offer if it is still valid.
  Future<void> accepte({required String offerId}) async {
    final alreadyAccepted = state.value?.offerAcceptedEntity != null;
    if (state.isLoading || alreadyAccepted) return;

    final activeOffer = _readActivePendingOffer(expectedOfferId: offerId);
    if (activeOffer == null) return;

    state = const AsyncLoading();

    try {
      final result = await _accepteOfferUsecase(offerId: offerId);

      // Clear the pending offer after successful acceptance.
      ref.read(newOfferControllerProvider.notifier).clearCurrent();

      // Move availability offline after accepting an offer.
      unawaited(_setOfflineBestEffort());

      state = AsyncData(
        AccepteOfferState(
          offerAcceptedEntity: result,
          doneEndsAt: result.cooldownUntil,
        ),
      );
    } on Failure catch (f, st) {
      state = AsyncError(f, st);
    } on Exception catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  // Clear the accepted offer state.
  void clear() {
    state = const AsyncData(AccepteOfferState());
  }

  // ---------------------------------------------------------------------------
  // Resume sync
  // ---------------------------------------------------------------------------

  // Sync the accepted/current offer from backend state.
  Future<void> syncAcceptedOfferFromBackend() async {
    if (_isSyncingFromBackend) return;

    _isSyncingFromBackend = true;

    try {
      final result = await ref.refresh(currentAndPendingOfferProvider.future);
      final currentOffer = result?.currentOffer;

      state = AsyncData(
        AccepteOfferState(
          offerAcceptedEntity: currentOffer,
          doneEndsAt: currentOffer?.cooldownUntil,
        ),
      );

      debugPrint(
        'Accepted offer synced from backend -> id=${currentOffer?.offerId}',
      );
    } on Exception catch (e, st) {
      state = AsyncError(e, st);
      debugPrint('Failed to sync accepted offer from backend: $e\n$st');
    } finally {
      _isSyncingFromBackend = false;
    }
  }

  // ---------------------------------------------------------------------------
  // Validation
  // ---------------------------------------------------------------------------

  // Read the current pending offer and make sure it is still valid.
  NewOfferEntity? _readActivePendingOffer({
    required String expectedOfferId,
  }) {
    final pendingOfferState = ref.read(newOfferControllerProvider);
    final pendingOffer = pendingOfferState.asData?.value.currentOffer;

    if (pendingOffer == null) {
      state = AsyncError(
        StateError('This offer is no longer available.'),
        StackTrace.current,
      );
      return null;
    }

    if (pendingOffer.offerId != expectedOfferId) {
      state = AsyncError(
        StateError('This offer is no longer the active pending offer.'),
        StackTrace.current,
      );
      return null;
    }

    if (!pendingOffer.expiresAt.isAfter(DateTime.now())) {
      ref.read(newOfferControllerProvider.notifier).clearCurrent();

      state = AsyncError(
        StateError('This offer has expired.'),
        StackTrace.current,
      );
      return null;
    }

    return pendingOffer;
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  // Best-effort move to offline after accepting an offer.
  Future<void> _setOfflineBestEffort() async {
    try {
      await ref
          .read(availabilityProvider.notifier)
          .requestSetOnline(value: false);
    } on Exception catch (e) {
      debugPrint('Failed to set availability offline: $e');
    }
  }
}

// Holds the accepted offer state.
@immutable
final class AccepteOfferState {
  const AccepteOfferState({
    this.offerAcceptedEntity,
    this.doneEndsAt,
  });

  final OfferAcceptedEntity? offerAcceptedEntity;

  /// Server cooldownUntil: when Done becomes enabled.
  final DateTime? doneEndsAt;
}
