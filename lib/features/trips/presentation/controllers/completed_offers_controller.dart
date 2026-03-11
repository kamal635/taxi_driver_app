import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/core/errors/failure.dart';
import 'package:taxi_driver_app/features/trips/domain/entities/completed_offers_result_entity.dart';
import 'package:taxi_driver_app/features/trips/domain/usecases/get_completed_offers_usecase.dart';
import 'package:taxi_driver_app/features/trips/presentation/controllers/setup_providers.dart';

final completedOffersControllerProvider =
    NotifierProvider<CompletedOffersController, CompletedOffersState>(
      CompletedOffersController.new,
    );

final class CompletedOffersController extends Notifier<CompletedOffersState> {
  late final GetCompletedOffersUseCase _getCompletedOffers;

  @override
  CompletedOffersState build() {
    _getCompletedOffers = ref.read(completedOffersUseCaseProvider);

    unawaited(Future.microtask(loadInitial));

    return const CompletedOffersState(isLoading: true);
  }

  // Load first screen state.
  Future<void> loadInitial() async {
    if (state.result != null) return;

    state = state.copyWith(
      isLoading: true,
      isRefreshing: false,
      error: null,
    );

    try {
      final data = await _fetchOffers(period: CompletedPeriod.all);

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

  // Change selected filter and keep old data visible.
  Future<void> changePeriod(CompletedPeriod period) async {
    final currentPeriod = state.result?.period;

    if (state.isLoading || state.isRefreshing || currentPeriod == period) {
      return;
    }

    final hasData = state.result != null;

    state = state.copyWith(
      isLoading: !hasData,
      isRefreshing: hasData,
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

  // Reload current filter.
  Future<void> refresh() async {
    final period = state.result?.period ?? CompletedPeriod.all;
    await changePeriod(period);
  }

  // Fetch data from domain layer.
  Future<CompletedOffersResultEntity?> _fetchOffers({
    required CompletedPeriod period,
  }) {
    return _getCompletedOffers(period: period);
  }
}

@immutable
final class CompletedOffersState {
  const CompletedOffersState({
    this.result,
    this.isLoading = false,
    this.isRefreshing = false,
    this.error,
  });

  final CompletedOffersResultEntity? result;
  final bool isLoading;
  final bool isRefreshing;
  final Object? error;

  static const Object _unset = Object();

  CompletedOffersState copyWith({
    Object? result = _unset,
    bool? isLoading,
    bool? isRefreshing,
    Object? error = _unset,
  }) {
    return CompletedOffersState(
      result: identical(result, _unset)
          ? this.result
          : result as CompletedOffersResultEntity?,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      error: identical(error, _unset) ? this.error : error,
    );
  }
}
