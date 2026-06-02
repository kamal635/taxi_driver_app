import 'dart:async';

import 'package:bawabat_al_saeq/features/home/domain/usecases/decline_offer_use_case.dart';
import 'package:bawabat_al_saeq/features/home/presentation/controllers/new_offer_controller.dart';
import 'package:bawabat_al_saeq/features/home/presentation/helpers/pending_offer_guard.dart';
import 'package:bawabat_al_saeq/features/home/presentation/providers/offer_providers.dart';
import 'package:bawabat_al_saeq/features/home/presentation/services/offer_stale_error_resolver.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final AsyncNotifierProvider<DeclineOfferController, void>
declineOfferControllerProvider =
    AsyncNotifierProvider.autoDispose<DeclineOfferController, void>(
      DeclineOfferController.new,
    );

/// Handles declining the current pending offer.
final class DeclineOfferController extends AsyncNotifier<void> {
  late final DeclineOfferUseCase _declineOfferUseCase;

  @override
  FutureOr<void> build() {
    _declineOfferUseCase = ref.read(declineOfferUseCaseProvider);
  }

  Future<void> decline({required String offerId}) async {
    if (state.isLoading) return;

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
      await _declineOfferUseCase(offerId: offerId);
      ref.read(newOfferControllerProvider.notifier).clearCurrent();
      state = const AsyncData<void>(null);
    } on Object catch (error, stackTrace) {
      _clearPendingOfferIfServerRejectedIt(
        error: error,
        offerId: offerId,
      );
      state = AsyncError(error, stackTrace);
    }
  }

  void _clearPendingOfferIfServerRejectedIt({
    required Object error,
    required String offerId,
  }) {
    if (!OfferStaleErrorResolver.isStaleOfferError(error)) return;

    ref
        .read(newOfferControllerProvider.notifier)
        .clearCurrentIfMatching(
          offerId,
        );
  }
}
