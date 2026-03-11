import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/core/errors/failure.dart';
import 'package:taxi_driver_app/features/home/domain/usecases/complete_offer_usecase.dart';
import 'package:taxi_driver_app/features/home/presentation/controllers/accepte_offer_controller.dart';
import 'package:taxi_driver_app/features/home/presentation/controllers/new_offer_controller.dart';
import 'package:taxi_driver_app/features/home/presentation/providers/setup_providers.dart';

//-------------------------------------------
//      - Complete Order Controller Provider -
//-------------------------------------------

final completeOfferControllerProvider =
    AsyncNotifierProvider<CompleteOfferController, void>(
      CompleteOfferController.new,
    );

//-------------------------------------------
//           - Complete Order Controller -
//-------------------------------------------

final class CompleteOfferController extends AsyncNotifier<void> {
  late final CompleteOfferUseCase _completeOrderUseCase;

  //-------------------------------------------
  //                - Build -
  //-------------------------------------------

  @override
  FutureOr<void> build() {
    _completeOrderUseCase = ref.read(completeOfferUseCaseProvider);
  }

  //-------------------------------------------
  //            - Complete Order -
  //-------------------------------------------

  Future<void> complete({required String offerId}) async {
    if (state.isLoading) return;

    state = const AsyncLoading();

    try {
      // Complete order on the server.
      await _completeOrderUseCase(offerId: offerId);

      // Clear accepted/current order after success.
      ref.read(accepteOfferControllerProvider.notifier).clear();

      // Clear pending/new offer after success.
      ref.read(newOfferControllerProvider.notifier).clearCurrent();

      // Finish in a clean idle state.
      state = const AsyncData(null);
    } on Failure catch (f, st) {
      state = AsyncError(f, st);
    } on Exception catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
