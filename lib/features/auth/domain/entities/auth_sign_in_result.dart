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

/// Base result for sign-in attempts.
sealed class AuthSignInResult {
  const AuthSignInResult();
}

/// Returned when sign-in succeeds and the driver can enter the app directly.
final class AuthSignedIn extends AuthSignInResult {
  const AuthSignedIn(this.authSession);

  final AuthSessionEntity authSession;
}

/// Returned when sign-in succeeds but the driver must set a password first.
final class AuthSetupRequired extends AuthSignInResult {
  const AuthSetupRequired(this.authSession);

  final AuthSessionEntity authSession;
}
