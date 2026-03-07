import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/core/errors/failure.dart';
import 'package:taxi_driver_app/features/home/domain/usecases/complete_order_usecase.dart';
import 'package:taxi_driver_app/features/home/presentation/controllers/accepte_offer_controller.dart';
import 'package:taxi_driver_app/features/home/presentation/controllers/new_offer_controller.dart';
import 'package:taxi_driver_app/features/home/presentation/providers/setup_providers.dart';

final completeOrderControllerProvider =
    AsyncNotifierProvider<CompleteOrderController, void>(
      CompleteOrderController.new,
    );

final class CompleteOrderController extends AsyncNotifier<void> {
  late final CompleteOrderUseCase _completeOrderUseCase;

  @override
  FutureOr<void> build() {
    _completeOrderUseCase = ref.read(completeOrderUseCaseProvider);
  }

  Future<void> complete({required String orderId}) async {
    if (state.isLoading) return;

    state = const AsyncLoading();

    try {
      // 1) Complete order on the server.
      await _completeOrderUseCase(orderId: orderId);

      // 2) Clear local home UI state inside the controller.
      await ref.read(accepteOfferControllerProvider.notifier).clear();
      await ref.read(newOfferControllerProvider.notifier).clearCurrent();

      // 3) Finish in a clean idle state.
      state = const AsyncData(null);
    } on Failure catch (f, st) {
      state = AsyncError(f, st);
    } on Exception catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
