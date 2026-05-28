import 'package:bawabat_al_saeq/core/errors/failure.dart';
import 'package:bawabat_al_saeq/features/auth/domain/entities/auth_sign_in_result.dart';
import 'package:bawabat_al_saeq/features/auth/domain/repositories/auth_repository.dart';

/// Executes the sign-in flow.
final class SignInUseCase {
  const SignInUseCase(this._repository);

  final AuthRepository _repository;

  Future<AuthSignInResult> call({
    required String phone,
    required String password,
    String? fcmToken,
  }) {
    final normalizedPhone = phone.trim();

    if (normalizedPhone.isEmpty || password.isEmpty) {
      throw const ValidationFailure(message: 'Missing login credentials');
    }

    return _repository.signIn(
      phone: normalizedPhone,
      password: password,
      fcmToken: fcmToken,
    );
  }
}
