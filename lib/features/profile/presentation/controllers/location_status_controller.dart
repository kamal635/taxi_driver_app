import 'package:bawabat_al_saeq/core/location/location_providers.dart';
import 'package:bawabat_al_saeq/core/location/location_service.dart';
import 'package:bawabat_al_saeq/core/location/location_status.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final locationStatusControllerProvider =
    AsyncNotifierProvider<LocationStatusController, LocationStatus>(
      LocationStatusController.new,
    );

class LocationStatusController extends AsyncNotifier<LocationStatus> {
  late final LocationService _locationService;

  @override
  Future<LocationStatus> build() {
    _locationService = ref.read(locationServiceProvider);
    return _locationService.checkStatus();
  }

  Future<void> refresh() {
    return _runAndRefresh();
  }

  Future<void> requestPermission() {
    return _runAndRefresh(() => _locationService.ensureReady());
  }

  Future<void> openAppSettings() {
    return _runAndRefresh(() => _locationService.openAppSettings());
  }

  Future<void> openLocationSettings() {
    return _runAndRefresh(() => _locationService.openLocationSettings());
  }

  Future<void> _runAndRefresh([Future<Object?> Function()? action]) async {
    if (state.isLoading) {
      return;
    }

    state = const AsyncLoading<LocationStatus>();
    state = await AsyncValue.guard(() async {
      await action?.call();
      return _locationService.checkStatus();
    });
  }
}
