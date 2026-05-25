import 'package:bawabat_al_saeq/core/networking/api_client.dart';
import 'package:bawabat_al_saeq/features/trips/data/mappers/completed_period_mapper.dart';
import 'package:bawabat_al_saeq/features/trips/data/models/completed_offers_result_model.dart';
import 'package:bawabat_al_saeq/features/trips/domain/entities/completed_offers_result_entity.dart';

/// Contract for loading completed trips from the backend.
abstract interface class CompletedOffersRemoteDataSource {
  Future<CompletedOffersResultModel> getCompletedOffers({
    required CompletedPeriod period,
  });
}

/// Remote implementation backed by [ApiClient].
final class CompletedOffersRemoteDataSourceImpl
    implements CompletedOffersRemoteDataSource {
  CompletedOffersRemoteDataSourceImpl({
    required this.apiClient,
  });

  final ApiClient apiClient;

  @override
  Future<CompletedOffersResultModel> getCompletedOffers({
    required CompletedPeriod period,
  }) async {
    final data = await apiClient.getJson(
      '/api/admin/orders/completed',
      query: {
        'period': completedPeriodToQuery(period),
      },
    );

    return CompletedOffersResultModel.fromJson(data);
  }
}
