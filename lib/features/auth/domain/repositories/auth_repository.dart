import 'package:bawabat_al_saeq/features/auth/domain/entities/auth_sign_in_result.dart';

/// Contract for authentication operations exposed to the domain layer.
abstract interface class AuthRepository {
  Future<AuthSignInResult> signIn({
    required String phone,
    required String password,
    String? fcmToken,
  });
}
