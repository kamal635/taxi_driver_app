import 'dart:async';

import 'package:bawabat_al_saeq/core/errors/failure.dart';
import 'package:bawabat_al_saeq/core/session/app_sign_out_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
