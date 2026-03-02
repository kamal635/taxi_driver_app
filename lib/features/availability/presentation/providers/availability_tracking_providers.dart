import 'dart:async' show unawaited;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/core/location/location_providers.dart';
import 'package:taxi_driver_app/features/availability/data/geolocator_location_tracker.dart';
import 'package:taxi_driver_app/features/availability/data/repositories/driver_location_repository_impl.dart';
import 'package:taxi_driver_app/features/availability/domain/repositories/location_tracker.dart';
import 'package:taxi_driver_app/features/availability/domain/usecases/start_location_tracking_usecase.dart';
import 'package:taxi_driver_app/features/availability/domain/usecases/stop_location_tracking_usecase.dart';

// 1) Tracker
final locationTrackerProvider = Provider<LocationTracker>((ref) {
  final tracker = GeolocatorLocationTracker(
    repository: ref.read(driverLocationRepositoryProvider),
  );
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
        trackerLocation: ref.read(locationTrackerProvider),
      );
    });
