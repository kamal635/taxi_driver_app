import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/core/networking/api_client.dart';
import 'package:taxi_driver_app/core/socket/socket_client_provider.dart';
import 'package:taxi_driver_app/features/home/data/datasources/remote/offer_remote_datasource.dart';
import 'package:taxi_driver_app/features/home/data/repositories/offer_repository_impl.dart';
import 'package:taxi_driver_app/features/home/domain/entities/current_and_pending_offer_entity.dart';
import 'package:taxi_driver_app/features/home/domain/repositories/offer_repo.dart';
import 'package:taxi_driver_app/features/home/domain/usecases/accepte_offer.dart';
import 'package:taxi_driver_app/features/home/domain/usecases/complete_order_usecase.dart';
import 'package:taxi_driver_app/features/home/domain/usecases/decline_offer_use_case.dart';
import 'package:taxi_driver_app/features/home/domain/usecases/get_current_and_pending_offer_usecase.dart';
import 'package:taxi_driver_app/features/home/domain/usecases/watch_new_offer_usecase.dart';

//-------------------------------------------
//          - Remote Data Source Provider -
//-------------------------------------------

final offerRemoteDatasourceImplProvider = Provider<OfferRemoteDatasource>((
  ref,
) {
  final socketClient = ref.read(socketClientProvider);
  final apiClient = ref.read(apiClientProvider);

  return OfferRemoteDatasourceImpl(
    socketClient: socketClient,
    apiClient: apiClient,
  );
});

//-------------------------------------------
//            - Repository Provider -
//-------------------------------------------

final offerRepositoryProvider = Provider<OfferRepository>((ref) {
  final dataSource = ref.read(offerRemoteDatasourceImplProvider);
  return OfferRepositoryImpl(remote: dataSource);
});

//-------------------------------------------
//         - Watch New Offer Use Case -
//-------------------------------------------

final watchNewOfferUsecaseProvider = Provider<WatchNewOfferUseCase>((ref) {
  final repo = ref.read(offerRepositoryProvider);
  return WatchNewOfferUseCase(offerRepository: repo);
});

//-------------------------------------------
//         - Accept Offer Use Case -
//-------------------------------------------

final accepteOfferUsecaseProvider = Provider<AccepteOfferUsecase>((ref) {
  final repo = ref.read(offerRepositoryProvider);
  return AccepteOfferUsecase(offerRepository: repo);
});

//-------------------------------------------
//         - Decline Offer Use Case -
//-------------------------------------------

final declineOfferUsecaseProvider = Provider<DeclineOfferUseCase>((ref) {
  final repo = ref.read(offerRepositoryProvider);
  return DeclineOfferUseCase(repo);
});

//-------------------------------------------
//   - Get Current And Pending Offer Use Case -
//-------------------------------------------

final getCurrentAndPendingOfferUseCaseProvider =
    Provider<GetCurrentAndPendingOfferUsecase>((ref) {
      final repo = ref.read(offerRepositoryProvider);
      return GetCurrentAndPendingOfferUsecase(repo: repo);
    });

final FutureProvider<CurrentAndPendingOfferEntity?>
currentAndPendingOfferProvider = FutureProvider((ref) async {
  final useCase = ref.read(getCurrentAndPendingOfferUseCaseProvider);
  return useCase();
});
//-------------------------------------------
//        - Complete Order Use Case -
//-------------------------------------------

final completeOrderUseCaseProvider = Provider<CompleteOrderUseCase>((ref) {
  final repo = ref.read(offerRepositoryProvider);
  return CompleteOrderUseCase(repo: repo);
});
