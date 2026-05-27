import 'package:bawabat_al_saeq/core/session/session_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Performs one-time application bootstrap before [runApp].
Future<ProviderContainer> bootstrapApplication() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Future.wait([
    SystemChrome.setPreferredOrientations(const [
      DeviceOrientation.portraitUp,
    ]),
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge),
  ]);

  _setDefaultSystemUiOverlayStyle();

  final container = ProviderContainer();
  await container.read(authSessionProvider).load();

  return container;
}

void _setDefaultSystemUiOverlayStyle() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarContrastEnforced: false,
    ),
  );
}
