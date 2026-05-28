import 'dart:async';

import 'package:bawabat_al_saeq/core/errors/failure.dart';
import 'package:bawabat_al_saeq/features/availability/presentation/controllers/availability_controller.dart';
import 'package:bawabat_al_saeq/features/home/domain/usecases/accept_offer_use_case.dart';
import 'package:bawabat_al_saeq/features/home/presentation/controllers/new_offer_controller.dart';
import 'package:bawabat_al_saeq/features/home/presentation/helpers/pending_offer_guard.dart';
import 'package:bawabat_al_saeq/features/home/presentation/providers/offer_providers.dart';
import 'package:bawabat_al_saeq/features/home/presentation/state/accept_offer_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      unawaited(_stopRuntimeLocallyAfterAccept());

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

  Future<void> _stopRuntimeLocallyAfterAccept() async {
    try {
      await ref
          .read(availabilityProvider.notifier)
          .stopRuntimeLocallyAfterAccept();
    } on Exception catch (error) {
      debugPrint(
        'Failed to stop availability runtime locally after accept: $error',
      );
    }
  }
}
