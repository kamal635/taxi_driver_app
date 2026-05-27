import 'dart:async';

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
  int _requestId = 0;

  @override
  CompletedOffersState build() {
    _getCompletedOffersUseCase = ref.read(getCompletedOffersUseCaseProvider);

    unawaited(Future<void>.microtask(loadInitial));

    return const CompletedOffersState(isLoading: true);
  }

  /// Loads the initial screen state once.
  Future<void> loadInitial() async {
    if (state.hasVisibleData) return;

    await _loadPeriod(
      period: state.selectedPeriod,
      hasVisibleData: false,
    );
  }

  /// Changes the selected filter while preserving current visible data.
  Future<void> changePeriod(CompletedPeriod period) async {
    if (!state.canChangePeriod || state.selectedPeriod == period) {
      return;
    }

    await _loadPeriod(
      period: period,
      hasVisibleData: state.hasVisibleData,
    );
  }

  /// Refreshes the current period.
  Future<void> refresh() async {
    if (!state.canChangePeriod) return;

    await _loadPeriod(
      period: state.selectedPeriod,
      hasVisibleData: state.hasVisibleData,
    );
  }

  Future<void> _loadPeriod({
    required CompletedPeriod period,
    required bool hasVisibleData,
  }) async {
    final currentRequestId = ++_requestId;

    state = state.copyWith(
      selectedPeriod: period,
      isLoading: !hasVisibleData,
      isRefreshing: hasVisibleData,
      error: null,
    );

    try {
      final data = await _getCompletedOffersUseCase(period: period);

      if (currentRequestId != _requestId) return;

      state = state.copyWith(
        selectedPeriod: data.period,
        result: data,
        isLoading: false,
        isRefreshing: false,
        error: null,
      );
    } on Object catch (error) {
      if (currentRequestId != _requestId) return;

      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        error: error,
      );
    }
  }
}
