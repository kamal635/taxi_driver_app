import 'package:taxi_driver_app/features/auth/domain/entities/auth_sign_in_result.dart';

abstract interface class AuthRepository {
  Future<AuthSignInResult> signIn({
    required String phone,
    required String password,
    String? fcmToken,
  });

  Future<String> setPassword({
    required String token,
    required String newPassword,
  });
}
