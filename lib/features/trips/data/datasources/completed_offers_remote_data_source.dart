import 'package:taxi_driver_app/core/networking/api_client.dart';
import 'package:taxi_driver_app/features/trips/data/mappers/completed_period_mapper.dart';
import 'package:taxi_driver_app/features/trips/data/models/completed_offers_result_model.dart';
import 'package:taxi_driver_app/features/trips/domain/entities/completed_offers_result_entity.dart';

abstract interface class CompletedOffersRemoteDataSource {
  Future<CompletedOffersResultModel> getCompletedOffers({
    required CompletedPeriod period,
  });
}

final class CompletedOffersRemoteDataSourceImpl
    implements CompletedOffersRemoteDataSource {
  CompletedOffersRemoteDataSourceImpl({required this.apiClient});

  final ApiClient apiClient;
  @override
  Future<CompletedOffersResultModel> getCompletedOffers({
    required CompletedPeriod period,
  }) async {
    final data = await apiClient.getJson(
      '/api/admin/orders/completed',
      query: {'period': completedPeriodToQuery(period)},
    );

    return CompletedOffersResultModel.fromJson(data);
  }
}
