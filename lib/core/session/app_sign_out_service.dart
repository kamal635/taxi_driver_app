import 'package:bawabat_al_saeq/core/session/session_providers.dart';
import 'package:bawabat_al_saeq/features/availability/presentation/controllers/availability_controller.dart';
import 'package:bawabat_al_saeq/features/home/presentation/controllers/accept_offer_controller.dart';
import 'package:bawabat_al_saeq/features/home/presentation/controllers/new_offer_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appSignOutServiceProvider = Provider<AppSignOutService>(
  AppSignOutService.new,
);

class AppSignOutService {
  AppSignOutService(this._ref);

  final Ref _ref;
  bool _isSigningOut = false;

  Future<void> signOut({bool notifyBackend = true}) async {
    if (_isSigningOut) return;
    _isSigningOut = true;

    try {
      await _turnOfflineBeforeSignOut(notifyBackend: notifyBackend);
      _clearRuntimeOfferState();

      await _ref.read(authSessionProvider).clear();
    } finally {
      _isSigningOut = false;
    }
  }

  Future<void> _turnOfflineBeforeSignOut({required bool notifyBackend}) async {
    final availabilityController = _ref.read(availabilityProvider.notifier);

    if (notifyBackend) {
      try {
        await availabilityController.requestSetOnline(value: false);
        return;
      } on Exception {
        // If the backend request fails, keep the sign out flow safe by
        // cleaning the local availability/runtime state before clearing
        // the session.
      }
    }

    try {
      await availabilityController.forceLocalOfflineCleanup();
    } on Exception {
      // Best-effort cleanup.
    }
  }

  void _clearRuntimeOfferState() {
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
  }
}
