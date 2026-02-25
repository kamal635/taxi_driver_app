class AuthTokens {
  const AuthTokens({
    required this.accessToken,
    required this.refreshToken,
  });

  final String accessToken;
  final String refreshToken;
}

sealed class AuthSignInResult {
  const AuthSignInResult();
}

final class AuthSignedIn extends AuthSignInResult {
  const AuthSignedIn(this.tokens);
  final AuthTokens tokens;
}

final class AuthSetupRequired extends AuthSignInResult {
  const AuthSetupRequired(this.tokens);
  final AuthTokens tokens;
}
