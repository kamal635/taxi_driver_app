import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/core/session/session_providers.dart';
import 'package:taxi_driver_app/features/availability/presentation/controllers/availability_controller.dart';
import 'package:taxi_driver_app/features/home/presentation/controllers/accept_offer_controller.dart';
import 'package:taxi_driver_app/features/home/presentation/controllers/new_offer_controller.dart';

final appSignOutServiceProvider = Provider<AppSignOutService>(
  AppSignOutService.new,
);

/// Performs app-level cleanup before clearing the session.
class AppSignOutService {
  AppSignOutService(this._ref);

  final Ref _ref;

  Future<void> signOut() async {
    try {
      await _ref
          .read(availabilityProvider.notifier)
          .requestSetOnline(value: false);
    } on Exception {
      // Best-effort cleanup.
    }

    try {
      _ref.read(newOfferControllerProvider.notifier)
        ..clearCurrent()
        ..clearError();
    } on Exception {
      // Best-effort cleanup.
    }

    try {
      _ref.read(acceptOfferControllerProvider.notifier).clear();
    } on Exception {
      // Best-effort cleanup.
    }

    await _ref.read(authSessionProvider).clear();
  }
}
