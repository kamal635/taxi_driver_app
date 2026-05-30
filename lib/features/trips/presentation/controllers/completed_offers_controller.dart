import 'dart:async';

import 'package:bawabat_al_saeq/features/trips/domain/entities/completed_offers_result_entity.dart';
import 'package:bawabat_al_saeq/features/trips/domain/usecases/get_completed_offers_use_case.dart';
import 'package:bawabat_al_saeq/features/trips/presentation/providers/trips_providers.dart';
import 'package:bawabat_al_saeq/features/trips/presentation/state/completed_offers_state.dart';
import 'package:bawabat_al_saeq/features/trips/presentation/storage/trips_commission_settings_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final completedOffersControllerProvider =
    NotifierProvider<CompletedOffersController, CompletedOffersState>(
      CompletedOffersController.new,
    );

/// Handles loading and filter changes for the trips screen.
final class CompletedOffersController extends Notifier<CompletedOffersState> {
  late final GetCompletedOffersUseCase _getCompletedOffersUseCase;
  late final TripsCommissionSettingsStorage _commissionSettingsStorage;
  int _requestId = 0;

  @override
  CompletedOffersState build() {
    _getCompletedOffersUseCase = ref.read(getCompletedOffersUseCaseProvider);
    _commissionSettingsStorage = ref.read(
      tripsCommissionSettingsStorageProvider,
    );

    unawaited(Future<void>.microtask(loadInitial));
    unawaited(Future<void>.microtask(_loadSavedCommissionPercentage));

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

  void setCommissionFromDate(DateTime? date) {
    final normalizedDate = _dateOnly(date);
    final currentToDate = state.commissionToDate;

    state = state.copyWith(
      commissionFromDate: normalizedDate,
      commissionToDate:
          normalizedDate != null &&
              currentToDate != null &&
              currentToDate.isBefore(normalizedDate)
          ? normalizedDate
          : currentToDate,
    );
  }

  void setCommissionToDate(DateTime? date) {
    final normalizedDate = _dateOnly(date);
    final currentFromDate = state.commissionFromDate;

    state = state.copyWith(
      commissionFromDate:
          normalizedDate != null &&
              currentFromDate != null &&
              currentFromDate.isAfter(normalizedDate)
          ? normalizedDate
          : currentFromDate,
      commissionToDate: normalizedDate,
    );
  }

  void clearCommissionDateRange() {
    state = state.copyWith(
      commissionFromDate: null,
      commissionToDate: null,
    );
  }

  void setCommissionPercentageText(String value) {
    state = state.copyWith(commissionPercentageText: value);

    final normalizedValue = _normalizePercentageTextForStorage(value);
    if (normalizedValue == null) return;

    unawaited(
      _commissionSettingsStorage.saveCommissionPercentageText(
        normalizedValue,
      ),
    );
  }

  Future<void> _loadSavedCommissionPercentage() async {
    final savedPercentage = await _commissionSettingsStorage
        .readCommissionPercentageText();
    final normalizedPercentage = _normalizePercentageTextForStorage(
      savedPercentage ?? '',
    );

    if (normalizedPercentage == null) return;
    if (state.commissionPercentageText == normalizedPercentage) return;

    state = state.copyWith(
      commissionPercentageText: normalizedPercentage,
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

String? _normalizePercentageTextForStorage(String value) {
  final normalized = value.trim().replaceAll(',', '.');
  if (normalized.isEmpty) return null;

  final percentage = num.tryParse(normalized);
  if (percentage == null || percentage.isNaN || percentage.isInfinite) {
    return null;
  }

  if (percentage < 0 || percentage > 100) return null;

  return normalized;
}

DateTime? _dateOnly(DateTime? value) {
  if (value == null) return null;

  return DateTime(value.year, value.month, value.day);
}
