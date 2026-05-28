import 'package:bawabat_al_saeq/core/errors/failure.dart';
import 'package:bawabat_al_saeq/features/account_security/domain/usecases/set_password_use_case.dart';
import 'package:bawabat_al_saeq/features/account_security/presentation/controllers/setup_password_result.dart';
import 'package:bawabat_al_saeq/features/account_security/presentation/providers/account_security_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final setupPasswordControllerProvider =
    AsyncNotifierProvider<SetupPasswordController, SetupPasswordResult?>(
      SetupPasswordController.new,
    );

/// Controls the set-password submission state for the UI.
final class SetupPasswordController
    extends AsyncNotifier<SetupPasswordResult?> {
  late final SetPasswordUseCase _setPasswordUseCase;
  int _submissionSequence = 0;

  @override
  SetupPasswordResult? build() {
    _setPasswordUseCase = ref.read(setPasswordUseCaseProvider);
    return null;
  }

  /// Submits the new password and updates the async UI state.
  Future<void> submit({required String newPassword}) async {
    if (state.isLoading) {
      return;
    }

    state = const AsyncLoading<SetupPasswordResult?>();

    try {
      final message = await _setPasswordUseCase(newPassword: newPassword);
      _submissionSequence += 1;

      state = AsyncData(
        SetupPasswordResult(
          submissionId: _submissionSequence,
          message: message,
        ),
      );
    } on Failure catch (failure, stackTrace) {
      state = AsyncError<SetupPasswordResult?>(failure, stackTrace);
    } on Exception catch (exception, stackTrace) {
      state = AsyncError<SetupPasswordResult?>(exception, stackTrace);
    }
  }

  /// Clears the current result and returns the controller to the idle state.
  void reset() {
    if (state.hasValue && state.asData?.value == null) {
      return;
    }

    state = const AsyncData<SetupPasswordResult?>(null);
  }
}
