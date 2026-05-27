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

  const AuthSessionSnapshot.readyUnauthenticated()
    : token = null,
      refreshToken = null,
      driverId = null,
      driverName = null,
      driverPhone = null,
      mustChangePassword = false,
      isReady = true;

  final String? token;
  final String? refreshToken;
  final String? driverId;
  final String? driverName;
  final String? driverPhone;
  final bool mustChangePassword;
  final bool isReady;

  bool get isLoggedIn =>
      _hasText(token) && _hasText(refreshToken) && _hasText(driverId);

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

  static bool _hasText(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AuthSessionSnapshot &&
            token == other.token &&
            refreshToken == other.refreshToken &&
            driverId == other.driverId &&
            driverName == other.driverName &&
            driverPhone == other.driverPhone &&
            mustChangePassword == other.mustChangePassword &&
            isReady == other.isReady;
  }

  @override
  int get hashCode => Object.hash(
    token,
    refreshToken,
    driverId,
    driverName,
    driverPhone,
    mustChangePassword,
    isReady,
  );
}
