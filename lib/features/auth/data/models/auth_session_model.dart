import 'package:bawabat_al_saeq/features/auth/domain/entities/auth_sign_in_result.dart';

/// Data model for the authenticated driver session returned by the backend.
class AuthSessionModel {
  const AuthSessionModel({
    required this.driverId,
    required this.accessToken,
    required this.refreshToken,
    required this.driverName,
    required this.driverPhone,
  });

  /// Creates a session model from the login response payload.
  ///
  /// The backend currently returns the session fields at the root level.
  factory AuthSessionModel.fromJson(Map<String, dynamic> json) {
    final accessToken = json['token']?.toString();
    final refreshToken = json['refreshToken']?.toString();
    final driverId = json['userId']?.toString();
    final driverName = json['name'].toString();
    final driverPhone = json['phone'].toString();

    if (accessToken == null || accessToken.isEmpty) {
      throw const FormatException('Missing token');
    }

    if (refreshToken == null || refreshToken.isEmpty) {
      throw const FormatException('Missing refreshToken');
    }

    if (driverId == null || driverId.isEmpty) {
      throw const FormatException('Missing driverId');
    }

    return AuthSessionModel(
      accessToken: accessToken,
      refreshToken: refreshToken,
      driverId: driverId,
      driverName: driverName,
      driverPhone: driverPhone,
    );
  }

  final String accessToken;
  final String refreshToken;
  final String driverId;
  final String driverName;
  final String driverPhone;

  /// Maps the data model into a domain entity.
  AuthSessionEntity toEntity() {
    return AuthSessionEntity(
      accessToken: accessToken,
      refreshToken: refreshToken,
      driverId: driverId,
      driverName: driverName,
      driverPhone: driverPhone,
    );
  }
}
