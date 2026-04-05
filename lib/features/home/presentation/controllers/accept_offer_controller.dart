import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/core/errors/failure.dart';
import 'package:taxi_driver_app/features/availability/presentation/controllers/availability_controller.dart';
import 'package:taxi_driver_app/features/home/domain/usecases/accept_offer_use_case.dart';
import 'package:taxi_driver_app/features/home/presentation/controllers/new_offer_controller.dart';
import 'package:taxi_driver_app/features/home/presentation/helpers/pending_offer_guard.dart';
import 'package:taxi_driver_app/features/home/presentation/providers/offer_providers.dart';
import 'package:taxi_driver_app/features/home/presentation/state/accept_offer_state.dart';

final acceptOfferControllerProvider =
    AsyncNotifierProvider<AcceptOfferController, AcceptOfferState>(
      AcceptOfferController.new,
    );

/// Handles accepting the current pending offer.
final class AcceptOfferController extends AsyncNotifier<AcceptOfferState> {
  late final AcceptOfferUseCase _acceptOfferUseCase;

  @override
  FutureOr<AcceptOfferState> build() {
    _acceptOfferUseCase = ref.read(acceptOfferUseCaseProvider);
    return const AcceptOfferState();
  }

  Future<void> accept({required String offerId}) async {
    final alreadyAccepted = state.value?.acceptedOffer != null;
    if (state.isLoading || alreadyAccepted) return;

    final activeOffer = readActivePendingOffer(
      ref: ref,
      expectedOfferId: offerId,
      onError: (error, stackTrace) {
        state = AsyncError(error, stackTrace);
      },
    );

    if (activeOffer == null) return;

    state = const AsyncLoading();

    try {
      final acceptedOffer = await _acceptOfferUseCase(offerId: offerId);

      ref.read(newOfferControllerProvider.notifier).clearCurrent();
      unawaited(_setOfflineBestEffort());

      state = AsyncData(
        AcceptOfferState(
          acceptedOffer: acceptedOffer,
          doneEndsAt: acceptedOffer.cooldownUntil,
        ),
      );
    } on Failure catch (failure, stackTrace) {
      state = AsyncError(failure, stackTrace);
    } on Exception catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  void clear() {
    state = const AsyncData(AcceptOfferState());
  }

  Future<void> _setOfflineBestEffort() async {
    try {
      await ref
          .read(availabilityProvider.notifier)
          .requestSetOnline(value: false);
    } on Exception catch (error) {
      debugPrint('Failed to set availability offline: $error');
    }
  }
}
