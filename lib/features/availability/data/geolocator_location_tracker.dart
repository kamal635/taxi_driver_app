import 'dart:async' show StreamController, StreamSubscription, Timer, unawaited;

import 'package:geolocator/geolocator.dart';
import 'package:taxi_driver_app/core/errors/failure.dart';
import 'package:taxi_driver_app/core/location/location_result.dart';
import 'package:taxi_driver_app/features/availability/domain/repositories/driver_location_repository.dart';
import 'package:taxi_driver_app/features/availability/domain/repositories/location_tracker.dart';

final class GeolocatorLocationTracker implements LocationTracker {
  GeolocatorLocationTracker({required DriverLocationRepository repository})
    : _repository = repository;

  final DriverLocationRepository _repository;

  final _failureController =
      StreamController<LocationFailureReason>.broadcast();

  StreamSubscription<ServiceStatus>? _serviceSub;

  Timer? _tick;

  /// -------------- 1- Start
  @override
  Future<void> start() async {
    if (_serviceSub != null || _tick != null) return;

    _serviceSub = Geolocator.getServiceStatusStream().listen((status) {
      if (status == ServiceStatus.disabled) {
        _failureController.add(LocationFailureReason.serviceDisabled);
      }
    });

    _tick = Timer.periodic(const Duration(seconds: 15), (_) {
      unawaited(_pollAndSendOnce());
    });

    // Optional: get first position immediately
    unawaited(_pollAndSendOnce());
  }

  /// -------------- 2- Stop
  @override
  Future<void> stop() async {
    await _serviceSub?.cancel();
    _serviceSub = null;

    _tick?.cancel();
    _tick = null;
  }

  /// -------------- 3- Stream to listen failure
  @override
  Stream<LocationFailureReason> get failures => _failureController.stream;

  @override
  Future<void> dispose() async {
    await stop();
    await _failureController.close();
  }

  /// --------------  Helper
  Future<void> _pollAndSendOnce() async {
    // 1) Get position (location-related failures)
    final Position p;
    try {
      p = await Geolocator.getCurrentPosition();
    } on Exception {
      _failureController.add(LocationFailureReason.unableToDetermine);
      return;
    }
    // 2) Send to server (network/server failures)
    try {
      await _repository.updateLocation(lat: p.latitude, lon: p.longitude);
    } on NetworkFailure {
      _failureController.add(LocationFailureReason.networkError);
    } on TimeoutFailure {
      _failureController.add(LocationFailureReason.networkError);
    } on Failure {
      // Any other backend failure (401/403/500/etc.)
      // You can decide later if you want a separate reason.
      _failureController.add(LocationFailureReason.unableToDetermine);
    }
  }
}
