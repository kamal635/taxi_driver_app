import 'dart:async';

import 'package:bawabat_al_saeq/features/home/domain/usecases/decline_offer_use_case.dart';
import 'package:bawabat_al_saeq/features/home/presentation/controllers/new_offer_controller.dart';
import 'package:bawabat_al_saeq/features/home/presentation/helpers/pending_offer_guard.dart';
import 'package:bawabat_al_saeq/features/home/presentation/providers/offer_providers.dart';
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

    final result = await AsyncValue.guard(
      () => _declineOfferUseCase(offerId: offerId),
    );

    state = result;

    if (!result.hasError) {
      ref.read(newOfferControllerProvider.notifier).clearCurrent();
    }
  }
}
