import 'package:bawabat_al_saeq/app/router/routes/app_router.dart';
import 'package:bawabat_al_saeq/core/session/session_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final session = ref.read(authSessionProvider);
  final router = AppRouter.create(session);

  ref.onDispose(router.dispose);
  return router;
});
