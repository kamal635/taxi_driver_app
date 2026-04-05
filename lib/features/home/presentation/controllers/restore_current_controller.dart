import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/features/home/domain/entities/current_and_pending_offer_entity.dart';
import 'package:taxi_driver_app/features/home/domain/usecases/get_current_and_pending_offer_use_case.dart';
import 'package:taxi_driver_app/features/home/presentation/providers/offer_providers.dart';

final restoreCurrentControllerProvider =
    AsyncNotifierProvider<
      RestoreCurrentController,
      CurrentAndPendingOfferEntity
    >(
      RestoreCurrentController.new,
    );

/// Restores the current/pending offer snapshot from the backend.
final class RestoreCurrentController
    extends AsyncNotifier<CurrentAndPendingOfferEntity> {
  late final GetCurrentAndPendingOfferUseCase _getCurrentAndPendingOfferUseCase;

  @override
  FutureOr<CurrentAndPendingOfferEntity> build() {
    _getCurrentAndPendingOfferUseCase = ref.read(
      getCurrentAndPendingOfferUseCaseProvider,
    );

    return const CurrentAndPendingOfferEntity.empty();
  }

  Future<void> restore() async {
    if (state.isLoading) return;

    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final result = await _getCurrentAndPendingOfferUseCase();
      return result ?? const CurrentAndPendingOfferEntity.empty();
    });
  }
}
