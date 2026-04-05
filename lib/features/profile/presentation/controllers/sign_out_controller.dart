import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/core/errors/failure.dart';
import 'package:taxi_driver_app/core/session/app_sign_out_service.dart';

/// Exposes the sign-out action and its loading/error state to the UI.
final signOutControllerProvider =
    AsyncNotifierProvider<SignOutController, bool>(
      SignOutController.new,
    );

class SignOutController extends AsyncNotifier<bool> {
  late final AppSignOutService _signOutService;

  @override
  FutureOr<bool> build() {
    _signOutService = ref.read(appSignOutServiceProvider);
    return false;
  }

  /// Signs the user out from the local app session.
  Future<void> signOut() async {
    if (state.isLoading) return;

    state = const AsyncLoading();

    try {
      await _signOutService.signOut();
      state = const AsyncData(true);
    } on Failure catch (failure, stackTrace) {
      state = AsyncError(failure, stackTrace);
    } on Exception catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }
}
