import 'package:flutter/foundation.dart';
import 'package:taxi_driver_app/features/trips/domain/entities/completed_offers_result_entity.dart';

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
