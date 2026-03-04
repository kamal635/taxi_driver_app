import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/core/session/session_providers.dart';
import 'package:taxi_driver_app/core/socket/socket_client_provider.dart';
import 'package:taxi_driver_app/features/availability/presentation/controllers/availability_controller.dart';
import 'package:taxi_driver_app/features/home/presentation/controllers/accepte_offer_controller.dart';
import 'package:taxi_driver_app/features/home/presentation/controllers/new_offer_controller.dart';

final appSignOutServiceProvider = Provider<AppSignOutService>(
  AppSignOutService.new,
);

class AppSignOutService {
  AppSignOutService(this._ref);
  final Ref _ref;

  Future<void> signOut() async {
    // 1) Stop offer streaming (also disconnects socket inside stop()).
    try {
      await _ref.read(newOfferControllerProvider.notifier).stop();
    } on Exception catch (_) {
      // ignore: best-effort cleanup
    }

    // 2) Clear accepted offer + countdown storage (prevents stale UI after re-login).
    try {
      await _ref.read(accepteOfferControllerProvider.notifier).clear();
    } on Exception catch (_) {
      // ignore
    }

    // 3) Ensure socket is disconnected (in case stop() wasn't called / failed).
    try {
      await _ref.read(socketClientProvider).disconnect();
    } on Exception catch (_) {
      // ignore
    }

    // 3) Ensure availability is offline.
    try {
      await _ref
          .read(availabilityProvider.notifier)
          .requestSetOnline(value: false);
    } on Exception catch (_) {
      // ignore
    }

    // 4) Clear auth session (tokens + driverId + mustChangePassword).
    await _ref.read(authSessionProvider).clear();
  }
}
