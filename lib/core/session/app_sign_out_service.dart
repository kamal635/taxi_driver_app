import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/core/session/session_providers.dart';
import 'package:taxi_driver_app/features/availability/presentation/controllers/availability_controller.dart';
import 'package:taxi_driver_app/features/home/presentation/controllers/accept_offer_controller.dart';
import 'package:taxi_driver_app/features/home/presentation/controllers/new_offer_controller.dart';

final appSignOutServiceProvider = Provider<AppSignOutService>(
  AppSignOutService.new,
);

class AppSignOutService {
  AppSignOutService(this._ref);

  final Ref _ref;

  Future<void> signOut() async {
    // 1) Ensure driver runtime is offline.
    try {
      await _ref
          .read(availabilityProvider.notifier)
          .requestSetOnline(value: false);
    } on Exception catch (_) {
      // ignore: best-effort cleanup
    }

    // 2) Clear pending/new offer state.
    try {
      _ref.read(newOfferControllerProvider.notifier)
        ..clearCurrent()
        ..clearError();
    } on Exception catch (_) {
      // ignore
    }

    // 3) Clear accepted offer state.
    try {
      _ref.read(accepteOfferControllerProvider.notifier).clear();
    } on Exception catch (_) {
      // ignore
    }

    // 4) Clear auth session.
    await _ref.read(authSessionProvider).clear();
  }
}
