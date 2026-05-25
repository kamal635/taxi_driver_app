import 'package:bawabat_al_saeq/core/session/session_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Performs one-time application bootstrap before [runApp].
Future<ProviderContainer> bootstrapApplication() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  final container = ProviderContainer();
  await container.read(authSessionProvider).load();

  return container;
}
