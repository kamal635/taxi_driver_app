import 'dart:async' show StreamController, StreamSubscription;

import 'package:geolocator/geolocator.dart';
import 'package:taxi_driver_app/core/location/location_result.dart';
import 'package:taxi_driver_app/features/availability/domain/repositories/location_tracker.dart';

final class GeolocatorLocationTracker implements LocationTracker {
  GeolocatorLocationTracker();

  final _failureController =
      StreamController<LocationFailureReason>.broadcast();

  StreamSubscription<ServiceStatus>? _serviceSub;

  @override
  Future<void> start() async {
    if (_serviceSub != null) return;

    _serviceSub = Geolocator.getServiceStatusStream().listen((status) {
      if (status == ServiceStatus.disabled) {
        _failureController.add(LocationFailureReason.serviceDisabled);
      }
    });
  }

  @override
  Future<void> stop() async {
    await _serviceSub?.cancel();
    _serviceSub = null;
  }

  @override
  Stream<LocationFailureReason> get failures => _failureController.stream;

  @override
  Future<void> dispose() async {
    await stop();
    await _failureController.close();
  }
}
