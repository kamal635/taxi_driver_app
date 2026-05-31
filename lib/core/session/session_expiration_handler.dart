import 'package:bawabat_al_saeq/core/session/session_providers.dart';
import 'package:bawabat_al_saeq/core/session/session_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Handles an expired/invalid authenticated session.
///
/// The default core implementation only clears the stored session. The app
/// layer can override [sessionExpirationHandlerProvider] with an implementation
/// that also cleans feature runtime state before clearing the session.
abstract interface class SessionExpirationHandler {
  Future<void> handleExpiredSession();
}

final sessionExpirationHandlerProvider = Provider<SessionExpirationHandler>((
  ref,
) {
  return LocalSessionExpirationHandler(ref.read(authSessionProvider));
});

final class LocalSessionExpirationHandler implements SessionExpirationHandler {
  const LocalSessionExpirationHandler(this._authSession);

  final AuthSession _authSession;

  @override
  Future<void> handleExpiredSession() {
    return _authSession.clear();
  }
}
