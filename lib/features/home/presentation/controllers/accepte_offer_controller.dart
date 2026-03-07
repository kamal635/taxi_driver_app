import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/core/errors/failure.dart';
import 'package:taxi_driver_app/features/availability/presentation/controllers/availability_controller.dart';
import 'package:taxi_driver_app/features/home/domain/entities/offer_entity.dart';
import 'package:taxi_driver_app/features/home/domain/usecases/accepte_offer.dart';
import 'package:taxi_driver_app/features/home/domain/usecases/get_current_order_usecase.dart';
import 'package:taxi_driver_app/features/home/presentation/controllers/new_offer_controller.dart';
import 'package:taxi_driver_app/features/home/presentation/providers/setup_providers.dart';

final accepteOfferControllerProvider =
    AsyncNotifierProvider<AccepteOfferController, AccepteOfferState>(
      AccepteOfferController.new,
    );

final class AccepteOfferController extends AsyncNotifier<AccepteOfferState> {
  late final AccepteOfferUsecase _accepteOfferUsecase;
  late final GetCurrentOrderUseCase _getCurrentOrder;

  @override
  FutureOr<AccepteOfferState> build() async {
    _accepteOfferUsecase = ref.read(accepteOfferUsecaseProvider);
    _getCurrentOrder = ref.read(getCurrentOrderUseCaseProvider);

    // Source of truth: ask server if there is an active trip.
    final current = await _getCurrentOrder();

    if (current == null) {
      return const AccepteOfferState();
    }

    return AccepteOfferState(
      offerAcceptedEntity: current,
      // Keep same field name used by UI for the Done countdown.
      doneEndsAt: current.cooldownUntil,
    );
  }

  Future<void> accepte({required String offeroId}) async {
    final alreadyAccepted = state.value?.offerAcceptedEntity != null;
    if (state.isLoading || alreadyAccepted) return;

    state = const AsyncLoading();

    try {
      // Accept offer (HTTP)
      final result = await _accepteOfferUsecase(offeroId: offeroId);

      await ref.read(newOfferControllerProvider.notifier).clearCurrent();

      // Reset availability state after a successful accept.
      ref.invalidate(availabilityProvider);

      // Update UI immediately (cooldownUntil comes from server)
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

  /// Clears only local UI state.
  /// Real completion should be done via /orders/:id/done (separate controller).
  Future<void> clear() async {
    state = const AsyncData(AccepteOfferState());
  }
}

@immutable
final class AccepteOfferState {
  const AccepteOfferState({
    this.offerAcceptedEntity,
    this.doneEndsAt,
  });

  final OfferAcceptedEntity? offerAcceptedEntity;

  /// Server cooldownUntil (when Done becomes enabled).
  final DateTime? doneEndsAt;
}
