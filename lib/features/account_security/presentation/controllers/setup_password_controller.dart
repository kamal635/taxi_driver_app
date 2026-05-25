import 'dart:async';

import 'package:bawabat_al_saeq/core/errors/failure.dart';
import 'package:bawabat_al_saeq/features/account_security/domain/usecases/set_password_use_case.dart';
import 'package:bawabat_al_saeq/features/account_security/presentation/providers/account_security_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final setupPasswordControllerProvider =
    AsyncNotifierProvider<SetupPasswordController, String?>(
      SetupPasswordController.new,
    );

/// Controls the set-password submission state for the UI.
class SetupPasswordController extends AsyncNotifier<String?> {
  late final SetPasswordUseCase _setPasswordUseCase;

  @override
  FutureOr<String?> build() {
    _setPasswordUseCase = ref.read(setPasswordUseCaseProvider);
    return null;
  }

  /// Submits the new password and updates the async UI state.
  Future<void> submit({required String newPassword}) async {
    state = const AsyncLoading();

    try {
      final message = await _setPasswordUseCase(newPassword: newPassword);
      state = AsyncData(message);
    } on Failure catch (failure, stackTrace) {
      state = AsyncError(failure, stackTrace);
    } on Exception catch (exception, stackTrace) {
      state = AsyncError(exception, stackTrace);
    }
  }

  /// Clears the current result and returns the controller to the idle state.
  void reset() {
    state = const AsyncData(null);
  }
}
