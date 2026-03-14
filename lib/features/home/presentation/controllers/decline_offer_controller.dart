import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/features/home/domain/entities/offer_entity.dart';
import 'package:taxi_driver_app/features/home/domain/usecases/decline_offer_use_case.dart';
import 'package:taxi_driver_app/features/home/presentation/controllers/new_offer_controller.dart';
import 'package:taxi_driver_app/features/home/presentation/providers/setup_providers.dart';

// Provides the decline offer controller.
final AsyncNotifierProvider<DeclineOfferController, void>
declineOfferControllerProvider =
    AsyncNotifierProvider.autoDispose<DeclineOfferController, void>(
      DeclineOfferController.new,
    );

final class DeclineOfferController extends AsyncNotifier<void> {
  late final DeclineOfferUseCase _declineOfferUseCase;

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  FutureOr<void> build() {
    _declineOfferUseCase = ref.read(declineOfferUsecaseProvider);
  }

  // ---------------------------------------------------------------------------
  // Decline
  // ---------------------------------------------------------------------------

  // Decline the current pending offer if it is still valid.
  Future<void> decline({required String offerId}) async {
    if (state.isLoading) return;

    final activeOffer = _readActivePendingOffer(expectedOfferId: offerId);
    if (activeOffer == null) return;

    state = const AsyncLoading();

    state = await AsyncValue.guard(
      () => _declineOfferUseCase(offerId: offerId),
    );

    if (!state.hasError) {
      // Clear the pending offer after a successful decline.
      ref.read(newOfferControllerProvider.notifier).clearCurrent();
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
}
