import 'package:bawabat_al_saeq/app/app.dart';
import 'package:bawabat_al_saeq/app/bootstrap/app_bootstrap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  final container = await bootstrapApplication();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const BawabatAlSaeqApp(),
    ),
  );
}
