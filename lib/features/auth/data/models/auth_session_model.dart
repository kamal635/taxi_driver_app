import 'package:bawabat_al_saeq/core/utils/json_reader.dart';
import 'package:bawabat_al_saeq/features/auth/domain/entities/auth_session_entity.dart';

/// Data model for the authenticated driver session returned by the backend.
final class AuthSessionModel {
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
    return AuthSessionModel(
      accessToken: JsonReader.requireString(json, 'token'),
      refreshToken: JsonReader.requireString(json, 'refreshToken'),
      driverId: JsonReader.requireString(json, 'userId'),
      driverName: JsonReader.optionalString(json, 'name') ?? '',
      driverPhone: JsonReader.optionalString(json, 'phone') ?? '',
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
