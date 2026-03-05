import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/core/networking/api_client.dart';
import 'package:taxi_driver_app/features/trips/data/datasources/completed_offers_remote_data_source.dart';
import 'package:taxi_driver_app/features/trips/data/repositories/completed_offers_repo_impl.dart';
import 'package:taxi_driver_app/features/trips/domain/repositories/completed_offers_repository.dart';
import 'package:taxi_driver_app/features/trips/domain/usecases/get_completed_offers_usecase.dart';

final completedOffersRemoteProvider = Provider<CompletedOffersRemoteDataSource>(
  (ref) {
    final apiClient = ref.read(apiClientProvider);
    return CompletedOffersRemoteDataSourceImpl(apiClient: apiClient);
  },
);

final completedOffersRepoProvider = Provider<CompletedOffersRepository>(
  (ref) {
    final remote = ref.read(completedOffersRemoteProvider);
    return CompletedOffersRepoImpl(remote: remote);
  },
);

final completedOffersUseCaseProvider = Provider<GetCompletedOffersUseCase>(
  (ref) {
    final repo = ref.read(completedOffersRepoProvider);
    return GetCompletedOffersUseCase(repo: repo);
  },
);
