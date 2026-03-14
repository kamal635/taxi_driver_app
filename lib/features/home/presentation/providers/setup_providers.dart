import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/core/networking/api_client.dart';
import 'package:taxi_driver_app/features/home/data/datasources/remote/offer_remote_datasource.dart';
import 'package:taxi_driver_app/features/home/data/repositories/offer_repository_impl.dart';
import 'package:taxi_driver_app/features/home/domain/entities/current_and_pending_offer_entity.dart';
import 'package:taxi_driver_app/features/home/domain/repositories/offer_repo.dart';
import 'package:taxi_driver_app/features/home/domain/usecases/accepte_offer.dart';
import 'package:taxi_driver_app/features/home/domain/usecases/complete_offer_usecase.dart';
import 'package:taxi_driver_app/features/home/domain/usecases/decline_offer_use_case.dart';
import 'package:taxi_driver_app/features/home/domain/usecases/get_current_and_pending_offer_usecase.dart';

//-------------------------------------------
//          - Remote Data Source Provider -
//-------------------------------------------

final offerRemoteDatasourceImplProvider = Provider<OfferRemoteDatasource>((
  ref,
) {
  final apiClient = ref.read(apiClientProvider);

  return OfferRemoteDatasourceImpl(
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
//         - Accept Offer Use Case -
//-------------------------------------------

final accepteOfferUsecaseProvider = Provider<AcceptOfferUseCase>((ref) {
  final repo = ref.read(offerRepositoryProvider);
  return AcceptOfferUseCase(offerRepository: repo);
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

final completeOfferUseCaseProvider = Provider<CompleteOfferUseCase>((ref) {
  final repo = ref.read(offerRepositoryProvider);
  return CompleteOfferUseCase(repo: repo);
});
