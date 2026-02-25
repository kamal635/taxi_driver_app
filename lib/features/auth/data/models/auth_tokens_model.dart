import 'package:taxi_driver_app/features/auth/domain/entities/auth_sign_in_result.dart';

class AuthTokensModel {
  const AuthTokensModel({
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthTokensModel.fromJson(Map<String, dynamic> json) {
    final access = json['token']?.toString();

    if (access == null || access.isEmpty) {
      throw const FormatException('Missing token');
    }

    return AuthTokensModel(
      accessToken: access,
      refreshToken: '',
    );
  }

  final String accessToken;
  final String refreshToken;

  AuthTokens toEntity() => AuthTokens(
    accessToken: accessToken,
    refreshToken: refreshToken,
  );
}
