import 'package:bawabat_al_saeq/core/networking/api_client.dart';
import 'package:bawabat_al_saeq/features/trips/data/mappers/completed_period_mapper.dart';
import 'package:bawabat_al_saeq/features/trips/data/models/completed_offers_result_model.dart';
import 'package:bawabat_al_saeq/features/trips/domain/entities/completed_period.dart';
import 'package:flutter/material.dart';

/// Contract for loading completed trips from the backend.
abstract interface class CompletedOffersRemoteDataSource {
  Future<CompletedOffersResultModel> getCompletedOffers({
    required CompletedPeriod period,
  });
}

/// Remote implementation backed by [ApiClient].
final class CompletedOffersRemoteDataSourceImpl
    implements CompletedOffersRemoteDataSource {
  const CompletedOffersRemoteDataSourceImpl({
    required this.apiClient,
  });

  static const String _completedOrdersEndpoint = '/api/admin/orders/completed';

  final ApiClient apiClient;

  @override
  Future<CompletedOffersResultModel> getCompletedOffers({
    required CompletedPeriod period,
  }) async {
    final stopwatch = Stopwatch()..start();
    final data = await apiClient.getJson(
      _completedOrdersEndpoint,
      query: {
        'period': completedPeriodToQuery(period),
      },
    );
    stopwatch.stop();
    debugPrint(
      'Completed trips API took: ${stopwatch.elapsedMilliseconds} ms',
    );
    return CompletedOffersResultModel.fromJson(data);
  }
}
