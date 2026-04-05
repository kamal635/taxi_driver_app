import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/core/errors/failure.dart';
import 'package:taxi_driver_app/features/auth/domain/entities/auth_sign_in_result.dart';
import 'package:taxi_driver_app/features/auth/domain/usecases/sign_in_use_case.dart';
import 'package:taxi_driver_app/features/auth/presentation/providers/auth_providers.dart';

final authControllerProvider =
    AsyncNotifierProvider<AuthController, AuthSignInResult?>(
      AuthController.new,
    );

/// Handles the sign-in request state for the UI layer.
class AuthController extends AsyncNotifier<AuthSignInResult?> {
  late final SignInUseCase _signInUseCase;

  @override
  Future<AuthSignInResult?> build() async {
    _signInUseCase = ref.read(signInUseCaseProvider);
    return null;
  }

  /// Submits the sign-in request and exposes the result as async state.
  Future<void> signIn({
    required String phone,
    required String password,
    String? fcmToken,
  }) async {
    state = const AsyncLoading();

    try {
      final result = await _signInUseCase(
        phone: phone,
        password: password,
        fcmToken: fcmToken,
      );

      state = AsyncData(result);
    } on Failure catch (failure, stackTrace) {
      state = AsyncError(failure, stackTrace);
    } on Exception catch (exception, stackTrace) {
      state = AsyncError(exception, stackTrace);
    }
  }
}
