import 'package:taxi_driver_app/core/location/location_result.dart';
import 'package:taxi_driver_app/core/location/location_service.dart';
import 'package:taxi_driver_app/features/availability/domain/repositories/location_tracker.dart';

/// Ensures location readiness, then starts tracking runtime failures.
final class StartLocationTrackingUseCase {
  StartLocationTrackingUseCase({
    required LocationTracker tracker,
    required LocationService locationService,
  })  : _tracker = tracker,
        _locationService = locationService;

  final LocationTracker _tracker;
  final LocationService _locationService;

  Future<LocationReadyResult> call() async {
    final readyResult = await _locationService.ensureReady();

    if (!readyResult.isSuccess) {
      return readyResult;
    }

    await _tracker.start();
    return LocationReadyResult.success();
  }
}
