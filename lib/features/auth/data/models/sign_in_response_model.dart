import 'package:bawabat_al_saeq/core/utils/json_reader.dart';
import 'package:bawabat_al_saeq/features/auth/data/models/auth_session_model.dart';
import 'package:bawabat_al_saeq/features/auth/domain/entities/auth_sign_in_result.dart';

/// Data model for the complete login response.
final class SignInResponseModel {
  const SignInResponseModel({
    required this.mustChangePassword,
    required this.authSession,
  });

  factory SignInResponseModel.fromJson(Map<String, dynamic> json) {
    return SignInResponseModel(
      mustChangePassword:
          JsonReader.optionalBool(json, 'mustChangePassword') ?? false,
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
