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
  bool build() {
    _signOutService = ref.read(appSignOutServiceProvider);
    return false;
  }

  /// Signs the driver out from the local app session.
  Future<void> signOut() async {
    if (state.isLoading) {
      return;
    }

    state = const AsyncLoading<bool>();

    try {
      await _signOutService.signOut();
      state = const AsyncData<bool>(true);
    } on Failure catch (failure, stackTrace) {
      state = AsyncError<bool>(failure, stackTrace);
    } on Object catch (error, stackTrace) {
      state = AsyncError<bool>(error, stackTrace);
    }
  }

  /// Returns the controller to the idle state after the UI consumes the result.
  void reset() {
    if (state.asData?.value == false) {
      return;
    }

    state = const AsyncData<bool>(false);
  }
}
