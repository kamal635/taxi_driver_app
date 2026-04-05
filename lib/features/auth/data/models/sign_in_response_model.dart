import 'package:taxi_driver_app/features/auth/data/models/auth_session_model.dart';
import 'package:taxi_driver_app/features/auth/domain/entities/auth_sign_in_result.dart';

/// Data model for the complete login response.
class SignInResponseModel {
  const SignInResponseModel({
    required this.mustChangePassword,
    required this.authSession,
  });

  factory SignInResponseModel.fromJson(Map<String, dynamic> json) {
    return SignInResponseModel(
      mustChangePassword: json['mustChangePassword'] == true,
      authSession: AuthSessionModel.fromJson(json),
    );
  }

  final bool mustChangePassword;
  final AuthSessionModel authSession;

  /// Maps the backend response into the appropriate domain result.
  AuthSignInResult toEntity() {
    final sessionEntity = authSession.toEntity();

    if (mustChangePassword) {
      return AuthSetupRequired(sessionEntity);
    }

    return AuthSignedIn(sessionEntity);
  }
}
