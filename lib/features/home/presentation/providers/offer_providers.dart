import 'package:bawabat_al_saeq/core/networking/providers/network_client_providers.dart';
import 'package:bawabat_al_saeq/features/home/data/datasources/remote/offer_remote_data_source.dart';
import 'package:bawabat_al_saeq/features/home/data/repositories/offer_repository_impl.dart';
import 'package:bawabat_al_saeq/features/home/domain/entities/offer_entity.dart';
import 'package:bawabat_al_saeq/features/home/domain/repositories/offer_repository.dart';
import 'package:bawabat_al_saeq/features/home/domain/usecases/accept_offer_use_case.dart';
import 'package:bawabat_al_saeq/features/home/domain/usecases/complete_offer_use_case.dart';
import 'package:bawabat_al_saeq/features/home/domain/usecases/decline_offer_use_case.dart';
import 'package:bawabat_al_saeq/features/home/domain/usecases/get_current_and_pending_offer_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

/// Data source provider.
final offerRemoteDataSourceProvider = Provider<OfferRemoteDataSource>((ref) {
  final apiClient = ref.read(apiClientProvider);

  return OfferRemoteDataSourceImpl(apiClient: apiClient);
});

/// Repository provider.
final offerRepositoryProvider = Provider<OfferRepository>((ref) {
  final dataSource = ref.read(offerRemoteDataSourceProvider);
  return OfferRepositoryImpl(remoteDataSource: dataSource);
});

/// Use case providers.
final acceptOfferUseCaseProvider = Provider<AcceptOfferUseCase>((ref) {
  final repository = ref.read(offerRepositoryProvider);
  return AcceptOfferUseCase(offerRepository: repository);
});

final declineOfferUseCaseProvider = Provider<DeclineOfferUseCase>((ref) {
  final repository = ref.read(offerRepositoryProvider);
  return DeclineOfferUseCase(repository);
});

final getCurrentAndPendingOfferUseCaseProvider =
    Provider<GetCurrentAndPendingOfferUseCase>((ref) {
      final repository = ref.read(offerRepositoryProvider);
      return GetCurrentAndPendingOfferUseCase(offerRepository: repository);
    });

final completeOfferUseCaseProvider = Provider<CompleteOfferUseCase>((ref) {
  final repository = ref.read(offerRepositoryProvider);
  return CompleteOfferUseCase(offerRepository: repository);
});

/// UI/session state helpers used by the presentation layer.
final restoredCurrentOfferProvider = StateProvider<OfferAcceptedEntity?>(
  (ref) => null,
);

final hasRequestedRestoreForCurrentOnlineSessionProvider = StateProvider<bool>(
  (ref) => false,
);

final hasBootstrappedCurrentRestoreProvider = StateProvider<bool>(
  (ref) => false,
);
