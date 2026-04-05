import 'dart:async' show StreamController, StreamSubscription;

import 'package:geolocator/geolocator.dart';
import 'package:taxi_driver_app/core/location/location_result.dart';
import 'package:taxi_driver_app/features/availability/domain/repositories/location_tracker.dart';

/// Listens to platform location-service
/// changes and exposes failures to the app.
final class GeolocatorLocationTracker implements LocationTracker {
  GeolocatorLocationTracker();

  final StreamController<LocationFailureReason> _failureController =
      StreamController<LocationFailureReason>.broadcast();

  StreamSubscription<ServiceStatus>? _serviceStatusSubscription;

  @override
  Stream<LocationFailureReason> get failures => _failureController.stream;

  @override
  Future<void> start() async {
    if (_serviceStatusSubscription != null) return;

    _serviceStatusSubscription = Geolocator.getServiceStatusStream().listen((
      status,
    ) {
      if (status == ServiceStatus.disabled) {
        _failureController.add(LocationFailureReason.serviceDisabled);
      }
    });
  }

  @override
  Future<void> stop() async {
    await _serviceStatusSubscription?.cancel();
    _serviceStatusSubscription = null;
  }

  @override
  Future<void> dispose() async {
    await stop();
    await _failureController.close();
  }
}
