import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/features/home/domain/entities/current_and_pending_offer_entity.dart';
import 'package:taxi_driver_app/features/home/domain/usecases/get_current_and_pending_offer_usecase.dart';
import 'package:taxi_driver_app/features/home/presentation/providers/setup_providers.dart';

final AsyncNotifierProvider<
  RestoreCurrentController,
  CurrentAndPendingOfferEntity
>
restoreCurrentControllerProvider =
    AsyncNotifierProvider<
      RestoreCurrentController,
      CurrentAndPendingOfferEntity
    >(
      RestoreCurrentController.new,
    );

final class RestoreCurrentController
    extends AsyncNotifier<CurrentAndPendingOfferEntity> {
  late final GetCurrentAndPendingOfferUsecase _getCurrentAndPendingOfferUsecase;

  @override
  FutureOr<CurrentAndPendingOfferEntity> build() {
    _getCurrentAndPendingOfferUsecase = ref.read(
      getCurrentAndPendingOfferUseCaseProvider,
    );

    return const CurrentAndPendingOfferEntity(
      currentOffer: null,
      pendingOffer: null,
    );
  }

  Future<void> restore() async {
    state = const AsyncValue.loading();

    final result = await _getCurrentAndPendingOfferUsecase();

    state = AsyncValue.data(
      result ??
          const CurrentAndPendingOfferEntity(
            currentOffer: null,
            pendingOffer: null,
          ),
    );
  }
}
