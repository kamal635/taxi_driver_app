import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/core/errors/failure.dart';
import 'package:taxi_driver_app/features/availability/presentation/controllers/availability_controller.dart';
import 'package:taxi_driver_app/features/home/domain/entities/offer_entity.dart';
import 'package:taxi_driver_app/features/home/domain/usecases/accepte_offer.dart';
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

  @override
  FutureOr<AccepteOfferState> build() async {
    _accepteOfferUsecase = ref.read(accepteOfferUsecaseProvider);

    final result = await ref.watch(currentAndPendingOfferProvider.future);
    final currentOffer = result?.currentOffer;

    return AccepteOfferState(
      offerAcceptedEntity: currentOffer,
      doneEndsAt: currentOffer?.cooldownUntil,
    );
  }

  Future<void> accepte({required String offeroId}) async {
    final alreadyAccepted = state.value?.offerAcceptedEntity != null;
    if (state.isLoading || alreadyAccepted) return;

    state = const AsyncLoading();

    try {
      final result = await _accepteOfferUsecase(offerId: offeroId);

      ref.read(newOfferControllerProvider.notifier).clearCurrent();

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

  void clear() {
    state = const AsyncData(AccepteOfferState());
  }

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
