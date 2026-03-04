import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/core/networking/api_client.dart';
import 'package:taxi_driver_app/core/socket/socket_client_provider.dart';
import 'package:taxi_driver_app/features/home/data/datasources/local/accepted_offer_storage.dart';
import 'package:taxi_driver_app/features/home/data/datasources/local/done_countdown_storage.dart';
import 'package:taxi_driver_app/features/home/data/datasources/remote/offer_remote_datasource.dart';
import 'package:taxi_driver_app/features/home/data/repositories/offer_repository_impl.dart';
import 'package:taxi_driver_app/features/home/domain/repositories/offer_repo.dart';
import 'package:taxi_driver_app/features/home/domain/usecases/accepte_offer.dart';
import 'package:taxi_driver_app/features/home/domain/usecases/decline_offer_use_case.dart';
import 'package:taxi_driver_app/features/home/domain/usecases/watch_new_offer_usecase.dart';

final offerRemoteDatasourceImplProvider = Provider<OfferRemoteDatasource>(
  (ref) {
    final socketClient = ref.read(socketClientProvider);
    final apiClient = ref.read(apiClientProvider);
    return OfferRemoteDatasourceImpl(
      socketClient: socketClient,
      apiClient: apiClient,
    );
  },
);

final offerRepositoryProvider = Provider<OfferRepository>((ref) {
  final ds = ref.read(offerRemoteDatasourceImplProvider);
  return OfferRepositoryImpl(remote: ds);
});

final watchNewOfferUsecaseProvider = Provider<WatchNewOfferUseCase>((ref) {
  final repo = ref.read(offerRepositoryProvider);
  return WatchNewOfferUseCase(offerRepository: repo);
});

final accepteOfferUsecaseProvider = Provider<AccepteOfferUsecase>((ref) {
  final repo = ref.read(offerRepositoryProvider);
  return AccepteOfferUsecase(offerRepository: repo);
});

final doneCountdownStorageProvider = Provider<DoneCountdownStorage>((ref) {
  return DoneCountdownStorage();
});

final acceptedOfferStorageProvider = Provider<AcceptedOfferStorage>((ref) {
  return AcceptedOfferStorage();
});

final declineOfferUsecaseProvider = Provider<DeclineOfferUseCase>((ref) {
  return DeclineOfferUseCase(ref.read(offerRepositoryProvider));
});
