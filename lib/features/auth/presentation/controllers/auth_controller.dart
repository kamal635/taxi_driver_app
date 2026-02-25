import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/core/errors/failure.dart';
import 'package:taxi_driver_app/features/auth/domain/entities/auth_sign_in_result.dart';
import 'package:taxi_driver_app/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:taxi_driver_app/features/auth/presentation/controllers/auth_usecases_providers.dart';

final authControllerProvider =
    AsyncNotifierProvider<AuthController, AuthSignInResult?>(
      AuthController.new,
    );

class AuthController extends AsyncNotifier<AuthSignInResult?> {
  late final SignInUseCase _signIn;

  @override
  Future<AuthSignInResult?> build() async {
    _signIn = ref.read(signInUseCaseProvider);
    return null; // initial
  }

  Future<void> signIn({
    required String phone,
    required String password,
    String? fcmToken,
  }) async {
    state = const AsyncLoading();
    try {
      final result = await _signIn(
        phone: phone,
        password: password,
        fcmToken: fcmToken,
      );
      state = AsyncData(result);
    } on Failure catch (f, st) {
      state = AsyncError(f, st);
    } on Exception catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
