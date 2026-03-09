import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/features/home/domain/usecases/decline_offer_use_case.dart';
import 'package:taxi_driver_app/features/home/presentation/controllers/new_offer_controller.dart';
import 'package:taxi_driver_app/features/home/presentation/providers/setup_providers.dart';

//-------------------------------------------
//      - Decline Offer Controller Provider -
//-------------------------------------------

final AsyncNotifierProvider<DeclineOfferController, void>
declineOfferControllerProvider =
    AsyncNotifierProvider.autoDispose<DeclineOfferController, void>(
      DeclineOfferController.new,
    );

//-------------------------------------------
//           - Decline Offer Controller -
//-------------------------------------------

final class DeclineOfferController extends AsyncNotifier<void> {
  late final DeclineOfferUseCase _declineOfferUseCase;

  //-------------------------------------------
  //                - Build -
  //-------------------------------------------

  @override
  FutureOr<void> build() {
    _declineOfferUseCase = ref.read(declineOfferUsecaseProvider);
  }

  //-------------------------------------------
  //            - Decline Offer -
  //-------------------------------------------

  Future<void> decline({required String offerId}) async {
    if (state.isLoading) return;

    state = const AsyncLoading();

    state = await AsyncValue.guard(
      () => _declineOfferUseCase(offeroId: offerId),
    );

    if (!state.hasError) {
      // Clear pending/new offer after successful decline.
      ref.read(newOfferControllerProvider.notifier).clearCurrent();
    }
  }
}
