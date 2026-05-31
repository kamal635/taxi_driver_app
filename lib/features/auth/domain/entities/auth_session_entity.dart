/// Domain entity representing the authenticated driver session.
final class AuthSessionEntity {
  const AuthSessionEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.driverId,
    required this.driverName,
    required this.driverPhone,
  });

  final String accessToken;
  final String refreshToken;
  final String driverId;
  final String driverName;
  final String driverPhone;
}
