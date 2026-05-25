import 'dart:async' show unawaited;

import 'package:bawabat_al_saeq/core/location/location_providers.dart';
import 'package:bawabat_al_saeq/core/networking/providers/network_client_providers.dart';
import 'package:bawabat_al_saeq/features/availability/data/datasources/remote/driver_status_remote_data_source.dart';
import 'package:bawabat_al_saeq/features/availability/data/repositories/driver_status_repository_impl.dart';
import 'package:bawabat_al_saeq/features/availability/data/trackers/geolocator_location_tracker.dart';
import 'package:bawabat_al_saeq/features/availability/domain/repositories/driver_status_repository.dart';
import 'package:bawabat_al_saeq/features/availability/domain/repositories/location_tracker.dart';
import 'package:bawabat_al_saeq/features/availability/domain/usecases/set_driver_status_use_case.dart';
import 'package:bawabat_al_saeq/features/availability/domain/usecases/start_location_tracking_use_case.dart';
import 'package:bawabat_al_saeq/features/availability/domain/usecases/stop_location_tracking_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1) Tracker
final locationTrackerProvider = Provider<LocationTracker>((ref) {
  final tracker = GeolocatorLocationTracker();
  ref.onDispose(() {
    unawaited(tracker.dispose());
  });
  return tracker;
});

// 2) UseCases
final startLocationTrackingUseCaseProvider =
    Provider<StartLocationTrackingUseCase>((ref) {
      return StartLocationTrackingUseCase(
        tracker: ref.read(locationTrackerProvider),
        locationService: ref.read(locationServiceProvider),
      );
    });

final stopLocationTrackingUseCaseProvider =
    Provider<StopLocationTrackingUseCase>((ref) {
      return StopLocationTrackingUseCase(
        tracker: ref.read(locationTrackerProvider),
      );
    });

// Remote datasource
final driverStatusRemoteDataSourceProvider =
    Provider<DriverStatusRemoteDataSource>(
      (ref) {
        final api = ref.read(apiClientProvider);
        return DriverStatusRemoteDataSourceImpl(apiClient: api);
      },
    );

// Repository
final driverStatusRepositoryProvider = Provider<DriverStatusRepository>(
  (ref) {
    final remote = ref.read(driverStatusRemoteDataSourceProvider);
    return DriverStatusRepositoryImpl(remoteDataSource: remote);
  },
);

// Usecase
final setDriverStatusUseCaseProvider = Provider<SetDriverStatusUseCase>(
  (ref) {
    final repo = ref.read(driverStatusRepositoryProvider);
    return SetDriverStatusUseCase(repository: repo);
  },
);
