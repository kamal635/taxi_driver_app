import 'package:taxi_driver_app/features/auth/domain/entities/auth_sign_in_result.dart';

class AuthSessionModel {
  const AuthSessionModel({
    required this.driverId,
    required this.accessToken,
    required this.refreshToken,
    required this.driverName,
    required this.driverPhone,
  });

  factory AuthSessionModel.fromJson(Map<String, dynamic> json) {
    final access = json['token']?.toString();
    final refreshToken = json['refreshToken']?.toString();
    final driverId = json['userId']?.toString();
    final driverName = json['phone'].toString();
    final driverPhone = json['name'].toString();

    if (access == null || access.isEmpty) {
      throw const FormatException('Missing token');
    }

    if (refreshToken == null || refreshToken.isEmpty) {
      throw const FormatException('Missing refreshToken');
    }
    if (driverId == null || driverId.isEmpty) {
      throw const FormatException('Missing driverId');
    }

    return AuthSessionModel(
      accessToken: access,
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

  AuthSessionEntity toEntity() => AuthSessionEntity(
    accessToken: accessToken,
    refreshToken: refreshToken,
    driverId: driverId,
    driverName: driverName,
    driverPhone: driverPhone,
  );
}
