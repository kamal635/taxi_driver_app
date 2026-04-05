import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_driver_app/app/router/app_router.dart';
import 'package:taxi_driver_app/core/session/session_providers.dart';

/// Provides the app-wide [GoRouter] instance.
final goRouterProvider = Provider<GoRouter>((ref) {
  final session = ref.read(authSessionProvider);
  final router = AppRouter.create(session);

  ref.onDispose(router.dispose);
  return router;
});
