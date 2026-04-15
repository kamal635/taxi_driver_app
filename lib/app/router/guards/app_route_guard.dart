import 'package:go_router/go_router.dart';
import 'package:taxi_driver_app/app/router/config/app_route_paths.dart';
import 'package:taxi_driver_app/app/router/guards/route_access_intent.dart';
import 'package:taxi_driver_app/core/session/session_store.dart';

enum SessionNavigationState {
  unauthenticated,
  passwordSetupRequired,
  authenticated,
}

final class AppRouteGuard {
  const AppRouteGuard._();

  static String? redirect({
    required AuthSession session,
    required GoRouterState state,
  }) {
    if (!session.isReady) {
      return null;
    }

    final targetPath = state.matchedLocation;
    final intent = _intentFor(targetPath);
    final sessionState = _sessionStateOf(session);

    return switch (sessionState) {
      SessionNavigationState.unauthenticated => _redirectForAnonymous(intent),
      SessionNavigationState.passwordSetupRequired => _redirectForPasswordSetup(
        intent,
      ),
      SessionNavigationState.authenticated => _redirectForAuthenticated(intent),
    };
  }

  static RouteAccessIntent _intentFor(String path) {
    return switch (path) {
      AppRoutePaths.login => RouteAccessIntent.anonymousOnly,
      AppRoutePaths.setupPassword => RouteAccessIntent.passwordSetupOnly,
      _ => RouteAccessIntent.authenticatedOnly,
    };
  }

  static SessionNavigationState _sessionStateOf(AuthSession session) {
    if (!session.isLoggedIn) {
      return SessionNavigationState.unauthenticated;
    }

    if (session.mustChangePassword) {
      return SessionNavigationState.passwordSetupRequired;
    }

    return SessionNavigationState.authenticated;
  }

  static String? _redirectForAnonymous(RouteAccessIntent intent) {
    return switch (intent) {
      RouteAccessIntent.anonymousOnly => null,
      RouteAccessIntent.passwordSetupOnly ||
      RouteAccessIntent.authenticatedOnly => AppRoutePaths.login,
    };
  }

  static String? _redirectForPasswordSetup(RouteAccessIntent intent) {
    return switch (intent) {
      RouteAccessIntent.passwordSetupOnly => null,
      RouteAccessIntent.anonymousOnly ||
      RouteAccessIntent.authenticatedOnly => AppRoutePaths.setupPassword,
    };
  }

  static String? _redirectForAuthenticated(RouteAccessIntent intent) {
    return switch (intent) {
      RouteAccessIntent.authenticatedOnly => null,
      RouteAccessIntent.anonymousOnly ||
      RouteAccessIntent.passwordSetupOnly => AppRoutePaths.home,
    };
  }
}
