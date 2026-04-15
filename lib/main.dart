import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/app/app.dart';
import 'package:taxi_driver_app/app/bootstrap/app_bootstrap.dart';

Future<void> main() async {
  final container = await bootstrapApplication();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const TaxiDriverApp(),
    ),
  );
}
