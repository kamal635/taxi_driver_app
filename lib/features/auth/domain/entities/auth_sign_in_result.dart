class AuthSessionEntity {
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

sealed class AuthSignInResult {
  const AuthSignInResult();
}

final class AuthSignedIn extends AuthSignInResult {
  const AuthSignedIn(this.authSessionEntity);

  final AuthSessionEntity authSessionEntity;
}

final class AuthSetupRequired extends AuthSignInResult {
  const AuthSetupRequired(this.authSessionEntity);
  final AuthSessionEntity authSessionEntity;
}
