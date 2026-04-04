import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/core/errors/failure.dart';
import 'package:taxi_driver_app/features/availability/presentation/controllers/availability_controller.dart';
import 'package:taxi_driver_app/features/home/domain/entities/offer_entity.dart';
import 'package:taxi_driver_app/features/home/domain/usecases/accepte_offer.dart';
import 'package:taxi_driver_app/features/home/presentation/controllers/new_offer_controller.dart';
import 'package:taxi_driver_app/features/home/presentation/providers/setup_providers.dart';

// Provides the accepted offer controller.
final accepteOfferControllerProvider =
    AsyncNotifierProvider<AccepteOfferController, AccepteOfferState>(
      AccepteOfferController.new,
    );

final class AccepteOfferController extends AsyncNotifier<AccepteOfferState> {
  late final AcceptOfferUseCase _accepteOfferUsecase;

  @override
  FutureOr<AccepteOfferState> build() {
    _accepteOfferUsecase = ref.read(accepteOfferUsecaseProvider);

    return const AccepteOfferState();
  }

  Future<void> accepte({required String offerId}) async {
    final alreadyAccepted = state.value?.offerAcceptedEntity != null;
    if (state.isLoading || alreadyAccepted) return;

    final activeOffer = _readActivePendingOffer(expectedOfferId: offerId);
    if (activeOffer == null) return;

    state = const AsyncLoading();

    try {
      final result = await _accepteOfferUsecase(offerId: offerId);

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

  NewOfferEntity? _readActivePendingOffer({
    required String expectedOfferId,
  }) {
    final pendingOfferState = ref.read(newOfferControllerProvider);
    final pendingOffer = pendingOfferState.asData?.value.currentOffer;

    if (pendingOffer == null) {
      state = AsyncError(
        StateError('This offer is no longer available.'),
        StackTrace.current,
      );
      return null;
    }

    if (pendingOffer.offerId != expectedOfferId) {
      state = AsyncError(
        StateError('This offer is no longer the active pending offer.'),
        StackTrace.current,
      );
      return null;
    }

    if (!pendingOffer.expiresAt.isAfter(DateTime.now())) {
      ref.read(newOfferControllerProvider.notifier).clearCurrent();

      state = AsyncError(
        StateError('This offer has expired.'),
        StackTrace.current,
      );
      return null;
    }

    return pendingOffer;
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

@immutable
final class AccepteOfferState {
  const AccepteOfferState({
    this.offerAcceptedEntity,
    this.doneEndsAt,
  });

  final OfferAcceptedEntity? offerAcceptedEntity;
  final DateTime? doneEndsAt;
}
