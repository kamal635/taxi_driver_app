import 'package:taxi_driver_app/features/auth/domain/entities/auth_sign_in_result.dart';

class AuthTokensModel {
  const AuthTokensModel({
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthTokensModel.fromJson(Map<String, dynamic> json) {
    final access = json['token']?.toString();
    final refreshToken = json['refreshToken']?.toString();

    if (access == null || access.isEmpty) {
      throw const FormatException('Missing token');
    }

    if (refreshToken == null || refreshToken.isEmpty) {
      throw const FormatException('Missing refreshToken');
    }

    return AuthTokensModel(
      accessToken: access,
      refreshToken: refreshToken,
    );
  }

  final String accessToken;
  final String refreshToken;

  AuthTokens toEntity() => AuthTokens(
    accessToken: accessToken,
    refreshToken: refreshToken,
  );
}
