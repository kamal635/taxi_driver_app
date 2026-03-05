import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/core/errors/failure.dart';
import 'package:taxi_driver_app/features/trips/domain/entities/completed_offers_result_entity.dart';
import 'package:taxi_driver_app/features/trips/domain/usecases/get_completed_offers_usecase.dart';
import 'package:taxi_driver_app/features/trips/presentation/controllers/setup_providers.dart';

final completedOffersControllerProvider =
    AsyncNotifierProvider<
      CompletedOffersController,
      CompletedOffersResultEntity?
    >(CompletedOffersController.new);

final class CompletedOffersController
    extends AsyncNotifier<CompletedOffersResultEntity?> {
  late final GetCompletedOffersUseCase _getOffers;
  @override
  FutureOr<CompletedOffersResultEntity?> build() {
    _getOffers = ref.read(completedOffersUseCaseProvider);
    return _getOffers(period: CompletedPeriod.all);
  }

  Future<void> getCompletedOffers(CompletedPeriod period) async {
    if (state.isLoading) return;
    state = const AsyncLoading();

    try {
      final data = await _getOffers(period: period);

      state = AsyncData(data);
    } on Failure catch (e, st) {
      state = AsyncError(e, st);
    } on Exception catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
