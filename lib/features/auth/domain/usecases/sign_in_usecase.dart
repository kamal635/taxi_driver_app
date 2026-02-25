import 'package:taxi_driver_app/features/auth/domain/entities/auth_sign_in_result.dart';
import 'package:taxi_driver_app/features/auth/domain/repositories/auth_repository.dart';

class SignInUseCase {
  const SignInUseCase(this._repo);

  final AuthRepository _repo;

  Future<AuthSignInResult> call({
    required String phone,
    required String password,
    String? fcmToken,
  }) {
    return _repo.signIn(
      phone: phone,
      password: password,
      fcmToken: fcmToken,
    );
  }
}
