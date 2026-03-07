import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/features/home/domain/usecases/decline_offer_use_case.dart';
import 'package:taxi_driver_app/features/home/presentation/controllers/new_offer_controller.dart';
import 'package:taxi_driver_app/features/home/presentation/providers/setup_providers.dart';

final AsyncNotifierProvider<DeclineOfferController, void>
declineOfferControllerProvider =
    AsyncNotifierProvider.autoDispose<DeclineOfferController, void>(
      DeclineOfferController.new,
    );

class DeclineOfferController extends AsyncNotifier<void> {
  late final DeclineOfferUseCase _declineOfferUseCase;

  @override
  FutureOr<void> build() {
    _declineOfferUseCase = ref.read(declineOfferUsecaseProvider);
  }

  Future<void> decline({required String offeroId}) async {
    if (state.isLoading) return;

    state = const AsyncLoading();

    state = await AsyncValue.guard(
      () => _declineOfferUseCase(offeroId: offeroId),
    );

    if (!state.hasError) {
      await ref.read(newOfferControllerProvider.notifier).clearCurrent();
    }
  }
}
