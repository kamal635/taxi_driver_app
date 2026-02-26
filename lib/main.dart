import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/app/app.dart';
import 'package:taxi_driver_app/core/session/session_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();

  await container.read(authSessionProvider).load();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const TaxiDriverApp(),
    ),
  );
}
