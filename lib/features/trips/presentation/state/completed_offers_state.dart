import 'package:bawabat_al_saeq/features/trips/domain/entities/completed_offers_result_entity.dart';
import 'package:flutter/foundation.dart';

@immutable
final class CompletedOffersState {
  const CompletedOffersState({
    this.selectedPeriod = CompletedPeriod.all,
    this.result,
    this.isLoading = false,
    this.isRefreshing = false,
    this.error,
    this.commissionFromDate,
    this.commissionToDate,
    this.commissionPercentageText = '8',
  });

  final CompletedPeriod selectedPeriod;
  final CompletedOffersResultEntity? result;
  final bool isLoading;
  final bool isRefreshing;
  final Object? error;
  final DateTime? commissionFromDate;
  final DateTime? commissionToDate;
  final String commissionPercentageText;

  bool get hasVisibleData => result != null;
  bool get isInitialLoading => isLoading && !hasVisibleData;
  bool get canChangePeriod => !isLoading && !isRefreshing;

  static const Object _unset = Object();

  CompletedOffersState copyWith({
    CompletedPeriod? selectedPeriod,
    Object? result = _unset,
    bool? isLoading,
    bool? isRefreshing,
    Object? error = _unset,
    Object? commissionFromDate = _unset,
    Object? commissionToDate = _unset,
    String? commissionPercentageText,
  }) {
    return CompletedOffersState(
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
      result: identical(result, _unset)
          ? this.result
          : result as CompletedOffersResultEntity?,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      error: identical(error, _unset) ? this.error : error,
      commissionFromDate: identical(commissionFromDate, _unset)
          ? this.commissionFromDate
          : commissionFromDate as DateTime?,
      commissionToDate: identical(commissionToDate, _unset)
          ? this.commissionToDate
          : commissionToDate as DateTime?,
      commissionPercentageText:
          commissionPercentageText ?? this.commissionPercentageText,
    );
  }
}
