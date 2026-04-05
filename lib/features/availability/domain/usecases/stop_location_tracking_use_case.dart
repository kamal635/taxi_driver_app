import 'package:taxi_driver_app/features/availability/domain/repositories/location_tracker.dart';

/// Stops runtime location tracking.
final class StopLocationTrackingUseCase {
  StopLocationTrackingUseCase({required LocationTracker tracker})
      : _tracker = tracker;

  final LocationTracker _tracker;

  Future<void> call() async {
    await _tracker.stop();
  }
}
