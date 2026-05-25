import 'dart:async';

import 'package:bawabat_al_saeq/core/errors/failure.dart';
import 'package:bawabat_al_saeq/features/trips/domain/entities/completed_offers_result_entity.dart';
import 'package:bawabat_al_saeq/features/trips/domain/usecases/get_completed_offers_use_case.dart';
import 'package:bawabat_al_saeq/features/trips/presentation/providers/trips_providers.dart';
import 'package:bawabat_al_saeq/features/trips/presentation/state/completed_offers_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final completedOffersControllerProvider =
    NotifierProvider<CompletedOffersController, CompletedOffersState>(
      CompletedOffersController.new,
    );

/// Handles loading and filter changes for the trips screen.
final class CompletedOffersController extends Notifier<CompletedOffersState> {
  late final GetCompletedOffersUseCase _getCompletedOffersUseCase;

  @override
  CompletedOffersState build() {
    _getCompletedOffersUseCase = ref.read(getCompletedOffersUseCaseProvider);

    unawaited(Future.microtask(loadInitial));

    return const CompletedOffersState(
      isLoading: true,
    );
  }

  /// Loads the initial screen state once.
  Future<void> loadInitial() async {
    if (state.result != null) return;

    state = state.copyWith(
      isLoading: true,
      isRefreshing: false,
      error: null,
    );

    await _loadPeriod(
      period: CompletedPeriod.all,
      hasVisibleData: false,
    );
  }

  /// Changes the selected filter while preserving current visible data.
  Future<void> changePeriod(CompletedPeriod period) async {
    final currentPeriod = state.result?.period;

    if (state.isLoading || state.isRefreshing || currentPeriod == period) {
      return;
    }

    await _loadPeriod(
      period: period,
      hasVisibleData: state.result != null,
    );
  }

  /// Refreshes the current period.
  Future<void> refresh() async {
    if (state.isLoading || state.isRefreshing) return;

    final period = state.result?.period ?? CompletedPeriod.all;

    await _loadPeriod(
      period: period,
      hasVisibleData: state.result != null,
    );
  }

  Future<void> _loadPeriod({
    required CompletedPeriod period,
    required bool hasVisibleData,
  }) async {
    state = state.copyWith(
      isLoading: !hasVisibleData,
      isRefreshing: hasVisibleData,
      error: null,
    );

    try {
      final data = await _fetchOffers(period: period);

      state = state.copyWith(
        result: data,
        isLoading: false,
        isRefreshing: false,
        error: null,
      );
    } on Failure catch (error) {
      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        error: error,
      );
    } on Exception catch (error) {
      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        error: error,
      );
    }
  }

  Future<CompletedOffersResultEntity> _fetchOffers({
    required CompletedPeriod period,
  }) {
    return _getCompletedOffersUseCase(period: period);
  }
}
