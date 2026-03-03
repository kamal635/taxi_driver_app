class AuthSessionEntity {
  const AuthSessionEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.driverId,
  });

  final String accessToken;
  final String refreshToken;
  final String driverId;
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
