import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/core/networking/api_client.dart';
import 'package:taxi_driver_app/features/trips/data/datasources/remote/completed_offers_remote_data_source.dart';
import 'package:taxi_driver_app/features/trips/data/repositories/completed_offers_repository_impl.dart';
import 'package:taxi_driver_app/features/trips/domain/repositories/completed_offers_repository.dart';
import 'package:taxi_driver_app/features/trips/domain/usecases/get_completed_offers_use_case.dart';

/// Remote data source provider.
final completedOffersRemoteDataSourceProvider =
    Provider<CompletedOffersRemoteDataSource>((ref) {
      final apiClient = ref.read(apiClientProvider);
      return CompletedOffersRemoteDataSourceImpl(apiClient: apiClient);
    });

/// Repository provider.
final completedOffersRepositoryProvider = Provider<CompletedOffersRepository>((
  ref,
) {
  final remoteDataSource = ref.read(completedOffersRemoteDataSourceProvider);
  return CompletedOffersRepositoryImpl(
    remoteDataSource: remoteDataSource,
  );
});

/// Use case provider.
final getCompletedOffersUseCaseProvider = Provider<GetCompletedOffersUseCase>((
  ref,
) {
  final repository = ref.read(completedOffersRepositoryProvider);
  return GetCompletedOffersUseCase(repository: repository);
});
