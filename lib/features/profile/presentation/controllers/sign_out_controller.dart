import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/core/errors/failure.dart';
import 'package:taxi_driver_app/core/session/app_sign_out_service.dart';

final signOutControllerProvider =
    AsyncNotifierProvider<SignOutController, bool>(
      SignOutController.new,
    );

class SignOutController extends AsyncNotifier<bool> {
  late final AppSignOutService _service;

  @override
  FutureOr<bool> build() async {
    _service = ref.read(appSignOutServiceProvider);
    return false; // not signed out
  }

  Future<void> signOut() async {
    if (state.isLoading) return;

    state = const AsyncLoading();
    try {
      await _service.signOut();
      state = const AsyncData(true);
    } on Failure catch (f, st) {
      state = AsyncError(f, st);
    } on Exception catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
