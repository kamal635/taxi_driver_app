import 'package:taxi_driver_app/features/auth/data/models/auth_tokens_model.dart';
import 'package:taxi_driver_app/features/auth/domain/entities/auth_sign_in_result.dart';

class SignInResponseModel {
  const SignInResponseModel({
    required this.mustChangePassword,
    required this.tokens,
  });

  factory SignInResponseModel.fromJson(Map<String, dynamic> json) {
    final mustChangePassword = json['mustChangePassword'] == true;

    final tokens = AuthTokensModel.fromJson(json);

    return SignInResponseModel(
      mustChangePassword: mustChangePassword,
      tokens: tokens,
    );
  }
  final bool mustChangePassword;
  final AuthTokensModel tokens;

  AuthSignInResult toEntity() {
    final entityTokens = tokens.toEntity();

    if (mustChangePassword) {
      return AuthSetupRequired(entityTokens);
    }
    return AuthSignedIn(entityTokens);
  }
}
