import 'package:taxi_driver_app/core/location/location_result.dart';
import 'package:taxi_driver_app/core/location/location_service.dart';
import 'package:taxi_driver_app/features/availability/domain/repositories/location_tracker.dart';

final class StartLocationTrackingUseCase {
  StartLocationTrackingUseCase({
    required this.tracker,
    required this.locationService,
  });

  final LocationTracker tracker;
  final LocationService locationService;

  Future<LocationReadyResult> call() async {
    final ready = await locationService.ensureReady();

    // If not ready, return the failure (with reason).
    if (!ready.isSuccess) {
      return ready;
    }

    // Ready -> start tracking.
    await tracker.start();

    // Return success to the caller.
    return LocationReadyResult.success();
  }
}
