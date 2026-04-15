import 'package:flutter/foundation.dart';

@immutable
class AuthSessionSnapshot {
  const AuthSessionSnapshot({
    required this.token,
    required this.refreshToken,
    required this.driverId,
    required this.driverName,
    required this.driverPhone,
    required this.mustChangePassword,
    required this.isReady,
  });

  const AuthSessionSnapshot.empty()
    : token = null,
      refreshToken = null,
      driverId = null,
      driverName = null,
      driverPhone = null,
      mustChangePassword = false,
      isReady = false;

  final String? token;
  final String? refreshToken;
  final String? driverId;
  final String? driverName;
  final String? driverPhone;
  final bool mustChangePassword;
  final bool isReady;

  bool get isLoggedIn =>
      token != null &&
      driverId != null &&
      token!.isNotEmpty &&
      driverId!.isNotEmpty;

  AuthSessionSnapshot copyWith({
    String? token,
    String? refreshToken,
    String? driverId,
    String? driverName,
    String? driverPhone,
    bool? mustChangePassword,
    bool? isReady,
    bool clearToken = false,
    bool clearRefreshToken = false,
    bool clearDriverId = false,
    bool clearDriverName = false,
    bool clearDriverPhone = false,
  }) {
    return AuthSessionSnapshot(
      token: clearToken ? null : token ?? this.token,
      refreshToken: clearRefreshToken
          ? null
          : refreshToken ?? this.refreshToken,
      driverId: clearDriverId ? null : driverId ?? this.driverId,
      driverName: clearDriverName ? null : driverName ?? this.driverName,
      driverPhone: clearDriverPhone ? null : driverPhone ?? this.driverPhone,
      mustChangePassword: mustChangePassword ?? this.mustChangePassword,
      isReady: isReady ?? this.isReady,
    );
  }
}
