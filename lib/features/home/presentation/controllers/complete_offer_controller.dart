import 'dart:async';

import 'package:bawabat_al_saeq/core/errors/failure.dart';
import 'package:bawabat_al_saeq/features/home/domain/usecases/complete_offer_use_case.dart';
import 'package:bawabat_al_saeq/features/home/presentation/controllers/accept_offer_controller.dart';
import 'package:bawabat_al_saeq/features/home/presentation/controllers/new_offer_controller.dart';
import 'package:bawabat_al_saeq/features/home/presentation/providers/offer_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final completeOfferControllerProvider =
    AsyncNotifierProvider<CompleteOfferController, void>(
      CompleteOfferController.new,
    );

/// Completes the current accepted offer.
final class CompleteOfferController extends AsyncNotifier<void> {
  late final CompleteOfferUseCase _completeOfferUseCase;

  @override
  FutureOr<void> build() {
    _completeOfferUseCase = ref.read(completeOfferUseCaseProvider);
  }

  Future<void> complete({required String offerId}) async {
    if (state.isLoading) return;

    state = const AsyncLoading();

    try {
      await _completeOfferUseCase(offerId: offerId);

      ref.read(acceptOfferControllerProvider.notifier).clear();
      ref.read(restoredCurrentOfferProvider.notifier).state = null;
      ref.read(newOfferControllerProvider.notifier).clearCurrent();

      state = const AsyncData(null);
    } on Failure catch (failure, stackTrace) {
      state = AsyncError(failure, stackTrace);
    } on Exception catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }
}
