import 'package:bawabat_al_saeq/features/auth/domain/entities/auth_session_entity.dart';

export 'package:bawabat_al_saeq/features/auth/domain/entities/auth_session_entity.dart';

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
