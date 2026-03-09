import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/core/errors/failure.dart';
import 'package:taxi_driver_app/features/availability/presentation/controllers/availability_controller.dart';
import 'package:taxi_driver_app/features/home/domain/entities/offer_entity.dart';
import 'package:taxi_driver_app/features/home/domain/usecases/accepte_offer.dart';
import 'package:taxi_driver_app/features/home/domain/usecases/get_current_and_pending_offer_usecase.dart';
import 'package:taxi_driver_app/features/home/presentation/controllers/new_offer_controller.dart';
import 'package:taxi_driver_app/features/home/presentation/providers/setup_providers.dart';

//-------------------------------------------
//      - Accepted Offer Controller Provider -
//-------------------------------------------

final accepteOfferControllerProvider =
    AsyncNotifierProvider<AccepteOfferController, AccepteOfferState>(
      AccepteOfferController.new,
    );

//-------------------------------------------
//         - Accepted Offer Controller -
//-------------------------------------------

final class AccepteOfferController extends AsyncNotifier<AccepteOfferState> {
  late final AccepteOfferUsecase _accepteOfferUsecase;
  late final GetCurrentAndPendingOfferUsecase _getCurrentAndPendingOfferUseCase;

  //-------------------------------------------
  //                - Build -
  //-------------------------------------------

  @override
  FutureOr<AccepteOfferState> build() async {
    _accepteOfferUsecase = ref.read(accepteOfferUsecaseProvider);
    _getCurrentAndPendingOfferUseCase = ref.read(
      getCurrentAndPendingOfferUseCaseProvider,
    );

    final result = await _getCurrentAndPendingOfferUseCase();
    final currentOffer = result?.currentOffer;

    // Best-effort: if a current accepted order exists,
    // force availability to offline.
    if (currentOffer != null) {
      unawaited(_setOfflineBestEffort());
    }

    return AccepteOfferState(
      offerAcceptedEntity: currentOffer,
      doneEndsAt: currentOffer?.cooldownUntil,
    );
  }

  //-------------------------------------------
  //            - Accept New Offer -
  //-------------------------------------------

  Future<void> accepte({required String offeroId}) async {
    final alreadyAccepted = state.value?.offerAcceptedEntity != null;
    if (state.isLoading || alreadyAccepted) return;

    state = const AsyncLoading();

    try {
      final result = await _accepteOfferUsecase(offeroId: offeroId);

      // Clear pending/new offer after successful accept.
      ref.read(newOfferControllerProvider.notifier).clearCurrent();

      // Best-effort: move driver to offline after accept.
      unawaited(_setOfflineBestEffort());

      state = AsyncData(
        AccepteOfferState(
          offerAcceptedEntity: result,
          doneEndsAt: result.cooldownUntil,
        ),
      );
    } on Failure catch (f, st) {
      state = AsyncError(f, st);
    } on Exception catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  //-------------------------------------------
  //             - Clear Accepted -
  //-------------------------------------------

  void clear() {
    state = const AsyncData(AccepteOfferState());
  }

  //-------------------------------------------
  //        - Availability Helper -
  //-------------------------------------------

  Future<void> _setOfflineBestEffort() async {
    try {
      await ref
          .read(availabilityProvider.notifier)
          .requestSetOnline(value: false);
    } on Exception catch (e) {
      debugPrint('Failed to set availability offline: $e');
    }
  }
}

//-------------------------------------------
//           - Accepted Offer State -
//-------------------------------------------

@immutable
final class AccepteOfferState {
  const AccepteOfferState({
    this.offerAcceptedEntity,
    this.doneEndsAt,
  });

  final OfferAcceptedEntity? offerAcceptedEntity;

  /// Server cooldownUntil: when Done becomes enabled.
  final DateTime? doneEndsAt;
}
