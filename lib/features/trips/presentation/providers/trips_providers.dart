import 'package:bawabat_al_saeq/core/networking/providers/network_client_providers.dart';
import 'package:bawabat_al_saeq/features/trips/data/datasources/remote/completed_offers_remote_data_source.dart';
import 'package:bawabat_al_saeq/features/trips/data/repositories/completed_offers_repository_impl.dart';
import 'package:bawabat_al_saeq/features/trips/domain/repositories/completed_offers_repository.dart';
import 'package:bawabat_al_saeq/features/trips/domain/usecases/get_completed_offers_use_case.dart';
import 'package:bawabat_al_saeq/features/trips/presentation/storage/trips_commission_settings_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Remote data source provider.
final completedOffersRemoteDataSourceProvider =
    Provider<CompletedOffersRemoteDataSource>((ref) {
      final apiClient = ref.watch(apiClientProvider);
      return CompletedOffersRemoteDataSourceImpl(apiClient: apiClient);
    });

/// Repository provider.
final completedOffersRepositoryProvider = Provider<CompletedOffersRepository>((
  ref,
) {
  final remoteDataSource = ref.watch(completedOffersRemoteDataSourceProvider);
  return CompletedOffersRepositoryImpl(remoteDataSource: remoteDataSource);
});

/// Use case provider.
final getCompletedOffersUseCaseProvider = Provider<GetCompletedOffersUseCase>((
  ref,
) {
  final repository = ref.watch(completedOffersRepositoryProvider);
  return GetCompletedOffersUseCase(repository: repository);
});

/// Secure storage instance used by trips local settings.
final tripsSecureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

/// Local storage for trips commission calculator settings.
final tripsCommissionSettingsStorageProvider =
    Provider<TripsCommissionSettingsStorage>((ref) {
      final storage = ref.watch(tripsSecureStorageProvider);
      return TripsCommissionSettingsStorage(storage);
    });
