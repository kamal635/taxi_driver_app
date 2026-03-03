import 'package:taxi_driver_app/features/auth/data/models/auth_tokens_model.dart';
import 'package:taxi_driver_app/features/auth/domain/entities/auth_sign_in_result.dart';

class SignInResponseModel {
  const SignInResponseModel({
    required this.mustChangePassword,
    required this.authSession,
  });

  factory SignInResponseModel.fromJson(Map<String, dynamic> json) {
    final mustChangePassword = json['mustChangePassword'] == true;

    final authSession = AuthSessionModel.fromJson(json);

    return SignInResponseModel(
      mustChangePassword: mustChangePassword,
      authSession: authSession,
    );
  }
  final bool mustChangePassword;
  final AuthSessionModel authSession;

  AuthSignInResult toEntity() {
    final authSessionEntity = authSession.toEntity();

    if (mustChangePassword) {
      return AuthSetupRequired(authSessionEntity);
    }
    return AuthSignedIn(authSessionEntity);
  }
}
