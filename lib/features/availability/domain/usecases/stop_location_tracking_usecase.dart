import 'package:taxi_driver_app/features/availability/domain/repositories/location_tracker.dart';

final class StopLocationTrackingUseCase {
  StopLocationTrackingUseCase({required this.trackerLocation});

  final LocationTracker trackerLocation;

  Future<void> call() async {
    await trackerLocation.stop();
  }
}
