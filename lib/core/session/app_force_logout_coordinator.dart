import 'dart:async' show StreamSubscription, unawaited;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/core/session/app_sign_out_service.dart';
import 'package:taxi_driver_app/features/availability/data/datasources/android/driver_background_service_bridge.dart';
import 'package:taxi_driver_app/features/availability/presentation/providers/availability_providers.dart';

final appForceLogoutCoordinatorProvider = Provider<AppForceLogoutCoordinator>((
  ref,
) {
  final coordinator = AppForceLogoutCoordinator(ref);
  unawaited(coordinator.start());

  ref.onDispose(coordinator.dispose);
  return coordinator;
});

class AppForceLogoutCoordinator {
  AppForceLogoutCoordinator(this._ref);

  final Ref _ref;

  StreamSubscription<DriverForceLogoutEvent>? _subscription;
  bool _isStarted = false;
  bool _isHandling = false;

  Future<void> start() async {
    if (_isStarted) return;
    _isStarted = true;

    final bridge = _ref.read(driverBackgroundServiceBridgeProvider);

    _subscription = bridge.forceLogoutEvents.listen((event) {
      unawaited(_handleForceLogout(event));
    });

    final pending = await bridge.consumePendingForceLogout();
    if (pending != null) {
      await _handleForceLogout(pending);
    }
  }

  Future<void> _handleForceLogout(DriverForceLogoutEvent event) async {
    if (_isHandling) return;
    _isHandling = true;

    try {
      debugPrint(
        'AppForceLogoutCoordinator -> force logout received: ${event.reason}',
      );

      await _ref
          .read(appSignOutServiceProvider)
          .signOut(
            notifyBackend: false,
          );
    } finally {
      _isHandling = false;
    }
  }

  void dispose() {
    unawaited(_subscription?.cancel());
    _subscription = null;
  }
}
