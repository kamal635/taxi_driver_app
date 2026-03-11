import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/features/home/presentation/controllers/new_offer_controller.dart';

final driverRuntimeControllerProvider = Provider<DriverRuntimeController>((
  ref,
) {
  return DriverRuntimeController(ref);
});

class DriverRuntimeController {
  DriverRuntimeController(this.ref);

  final Ref ref;

  Future<void> startOnlineRuntime() async {
    await ref.read(newOfferControllerProvider.notifier).start();
  }

  Future<void> stopOnlineRuntime() async {
    await ref.read(newOfferControllerProvider.notifier).stop();
  }
}
