import 'dart:async' show StreamController, StreamSubscription;

import 'package:bawabat_al_saeq/core/location/location_result.dart';
import 'package:bawabat_al_saeq/features/availability/domain/repositories/location_tracker.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

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

    _serviceStatusSubscription = Geolocator.getServiceStatusStream().listen(
      _handleServiceStatus,
      onError: (Object error, StackTrace stackTrace) {
        debugPrint(
          'Location service status stream failed: $error\n$stackTrace',
        );
        _addFailure(LocationFailureReason.unableToDetermine);
      },
    );
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

  void _handleServiceStatus(ServiceStatus status) {
    if (status != ServiceStatus.disabled) return;
    _addFailure(LocationFailureReason.serviceDisabled);
  }

  void _addFailure(LocationFailureReason reason) {
    if (_failureController.isClosed) return;
    _failureController.add(reason);
  }
}
