import 'package:bawabat_al_saeq/features/auth/domain/entities/auth_sign_in_result.dart';
import 'package:bawabat_al_saeq/features/auth/domain/repositories/auth_repository.dart';

/// Executes the sign-in flow.
class SignInUseCase {
  const SignInUseCase(this._repository);

  final AuthRepository _repository;

  Future<AuthSignInResult> call({
    required String phone,
    required String password,
    String? fcmToken,
  }) {
    return _repository.signIn(
      phone: phone,
      password: password,
      fcmToken: fcmToken,
    );
  }
}
