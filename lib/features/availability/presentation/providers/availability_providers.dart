import 'dart:async' show unawaited;

import 'package:bawabat_al_saeq/core/location/location_providers.dart';
import 'package:bawabat_al_saeq/core/networking/providers/network_client_providers.dart';
import 'package:bawabat_al_saeq/features/availability/data/datasources/android/driver_background_service_bridge.dart';
import 'package:bawabat_al_saeq/features/availability/data/datasources/local/availability_local_data_source.dart';
import 'package:bawabat_al_saeq/features/availability/data/datasources/remote/driver_status_remote_data_source.dart';
import 'package:bawabat_al_saeq/features/availability/data/repositories/driver_status_repository_impl.dart';
import 'package:bawabat_al_saeq/features/availability/data/trackers/geolocator_location_tracker.dart';
import 'package:bawabat_al_saeq/features/availability/domain/repositories/driver_status_repository.dart';
import 'package:bawabat_al_saeq/features/availability/domain/repositories/location_tracker.dart';
import 'package:bawabat_al_saeq/features/availability/domain/usecases/set_driver_status_use_case.dart';
import 'package:bawabat_al_saeq/features/availability/domain/usecases/start_location_tracking_use_case.dart';
import 'package:bawabat_al_saeq/features/availability/domain/usecases/stop_location_tracking_use_case.dart';
import 'package:bawabat_al_saeq/features/availability/presentation/controllers/driver_runtime_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provides access to the native Android background service bridge.
final driverBackgroundServiceBridgeProvider =
    Provider<DriverBackgroundServiceBridge>((ref) {
      final bridge = DriverBackgroundServiceBridge();

      ref.onDispose(bridge.dispose);

      return bridge;
    });

/// Provides local persistence for availability intent.
final availabilityLocalDataSourceProvider =
    Provider<AvailabilityLocalDataSource>(
      (ref) {
        return AvailabilityLocalDataSource(
          preferencesFuture: SharedPreferences.getInstance(),
        );
      },
    );

/// Provides a tracker that listens to runtime location-service failures.
final locationTrackerProvider = Provider<LocationTracker>((ref) {
  final tracker = GeolocatorLocationTracker();

  ref.onDispose(() {
    unawaited(tracker.dispose());
  });

  return tracker;
});

/// Provides the remote data source responsible for driver status updates.
final driverStatusRemoteDataSourceProvider =
    Provider<DriverStatusRemoteDataSource>((ref) {
      return DriverStatusRemoteDataSourceImpl(
        apiClient: ref.read(apiClientProvider),
      );
    });

/// Provides the driver status repository.
final driverStatusRepositoryProvider = Provider<DriverStatusRepository>((ref) {
  return DriverStatusRepositoryImpl(
    remoteDataSource: ref.read(driverStatusRemoteDataSourceProvider),
  );
});

/// Provides the use case that sets the driver's backend status.
final setDriverStatusUseCaseProvider = Provider<SetDriverStatusUseCase>((ref) {
  return SetDriverStatusUseCase(
    repository: ref.read(driverStatusRepositoryProvider),
  );
});

/// Provides the use case that starts location tracking.
final startLocationTrackingUseCaseProvider =
    Provider<StartLocationTrackingUseCase>((ref) {
      return StartLocationTrackingUseCase(
        tracker: ref.read(locationTrackerProvider),
        locationService: ref.read(locationServiceProvider),
      );
    });

/// Provides the use case that stops location tracking.
final stopLocationTrackingUseCaseProvider =
    Provider<StopLocationTrackingUseCase>((ref) {
      return StopLocationTrackingUseCase(
        tracker: ref.read(locationTrackerProvider),
      );
    });

/// Provides the runtime controller for the online driver mode.
final driverRuntimeControllerProvider = Provider<DriverRuntimeController>(
  DriverRuntimeController.new,
);
