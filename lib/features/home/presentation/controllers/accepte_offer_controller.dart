import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/core/errors/failure.dart';
import 'package:taxi_driver_app/features/home/domain/entities/offer_entity.dart';
import 'package:taxi_driver_app/features/home/domain/usecases/accepte_offer.dart';
import 'package:taxi_driver_app/features/home/presentation/providers/setup_providers.dart';

final accepteOfferControllerProvider =
    AsyncNotifierProvider<AccepteOfferController, AccepteOfferState>(
      AccepteOfferController.new,
    );

final class AccepteOfferController extends AsyncNotifier<AccepteOfferState> {
  late final AccepteOfferUsecase _accepteOfferUsecase;

  @override
  FutureOr<AccepteOfferState> build() async {
    _accepteOfferUsecase = ref.read(accepteOfferUsecaseProvider);

    final doneStorage = ref.read(doneCountdownStorageProvider);
    final offerStorage = ref.read(acceptedOfferStorageProvider);

    final endsAt = await doneStorage.readEndsAt();
    final accepted = await offerStorage.readAccepted();

    // If one exists without the other, clear both (keep things consistent).
    if ((endsAt == null) != (accepted == null)) {
      await doneStorage.clear();
      await offerStorage.clear();
      return const AccepteOfferState();
    }

    if (endsAt == null || accepted == null) {
      return const AccepteOfferState();
    }

    // If expired, clear both.
    if (!endsAt.isAfter(DateTime.now())) {
      await doneStorage.clear();
      await offerStorage.clear();
      return const AccepteOfferState();
    }

    return AccepteOfferState(
      offerAcceptedEntity: accepted,
      doneEndsAt: endsAt,
    );
  }

  Future<void> accepte({required String offeroId}) async {
    final alreadyAccepted = state.value?.offerAcceptedEntity != null;

    final hasActiveCountdown =
        state.value?.doneEndsAt != null &&
        state.value!.doneEndsAt!.isAfter(DateTime.now());

    if (state.isLoading || alreadyAccepted || hasActiveCountdown) return;

    state = const AsyncLoading();

    try {
      final result = await _accepteOfferUsecase(offeroId: offeroId);

      final doneStorage = ref.read(doneCountdownStorageProvider);
      final offerStorage = ref.read(acceptedOfferStorageProvider);

      final endsAtUtc = DateTime.now().toUtc().add(const Duration(minutes: 5));

      // Save both: endsAt + accepted payload
      await doneStorage.saveEndsAt(endsAtUtc);
      await offerStorage.saveAccepted(result);

      state = AsyncData(
        AccepteOfferState(
          offerAcceptedEntity: result,
          doneEndsAt: endsAtUtc.toLocal(),
        ),
      );
    } on Failure catch (f, st) {
      state = AsyncError(f, st);
    } on Exception catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> clear() async {
    await ref.read(doneCountdownStorageProvider).clear();
    await ref.read(acceptedOfferStorageProvider).clear();
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
  final DateTime? doneEndsAt;
}
