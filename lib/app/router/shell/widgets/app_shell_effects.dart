import 'dart:async' show FutureOr, StreamSubscription, unawaited;

import 'package:bawabat_al_saeq/app/router/config/app_route_paths.dart';
import 'package:bawabat_al_saeq/features/availability/data/datasources/android/driver_background_service_bridge.dart';
import 'package:bawabat_al_saeq/features/availability/presentation/controllers/availability_controller.dart';
import 'package:bawabat_al_saeq/features/availability/presentation/providers/availability_providers.dart';
import 'package:bawabat_al_saeq/features/home/domain/entities/current_and_pending_offer_entity.dart';
import 'package:bawabat_al_saeq/features/home/presentation/controllers/new_offer_controller.dart';
import 'package:bawabat_al_saeq/features/home/presentation/controllers/restore_current_controller.dart';
import 'package:bawabat_al_saeq/features/home/presentation/providers/offer_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AppShellEffects extends ConsumerStatefulWidget {
  const AppShellEffects({super.key});

  @override
  ConsumerState<AppShellEffects> createState() => _AppShellEffectsState();
}

class _AppShellEffectsState extends ConsumerState<AppShellEffects> {
  AppLifecycleListener? _appLifecycleListener;

  ProviderSubscription<AsyncValue<CurrentAndPendingOfferEntity>>?
  _restoreSubscription;

  StreamSubscription<DriverOfferNotificationOpenEvent>?
  _offerNotificationOpenSubscription;

  @override
  void initState() {
    super.initState();

    _appLifecycleListener = AppLifecycleListener(
      onResume: _handleAppResumed,
    );

    _setupRestoreSubscription();
    _setupOfferNotificationListener();
    _runAfterFirstFrame(_bootstrapCurrentOfferRestore);
    _runAfterFirstFrame(_consumePendingOfferNotificationOpen);
  }

  void _setupRestoreSubscription() {
    _restoreSubscription = ref
        .listenManual<AsyncValue<CurrentAndPendingOfferEntity>>(
          restoreCurrentControllerProvider,
          (previous, next) {
            final restoredData = next.asData?.value;
            if (restoredData == null) return;

            ref.read(restoredCurrentOfferProvider.notifier).state =
                restoredData.currentOffer;
          },
        );
  }

  void _setupOfferNotificationListener() {
    final bridge = ref.read(driverBackgroundServiceBridgeProvider);

    _offerNotificationOpenSubscription = bridge.offerNotificationOpens.listen(
      _handleOfferNotificationOpen,
    );
  }

  void _bootstrapCurrentOfferRestore() {
    final hasBootstrapped = ref.read(hasBootstrappedCurrentRestoreProvider);
    if (hasBootstrapped) return;

    ref.read(hasBootstrappedCurrentRestoreProvider.notifier).state = true;

    unawaited(
      ref.read(restoreCurrentControllerProvider.notifier).restore(),
    );
  }

  Future<void> _consumePendingOfferNotificationOpen() async {
    final pendingEvent = await ref
        .read(driverBackgroundServiceBridgeProvider)
        .consumePendingOfferNotificationOpen();

    if (!mounted || pendingEvent == null) return;

    _handleOfferNotificationOpen(pendingEvent);
  }

  void _handleOfferNotificationOpen(DriverOfferNotificationOpenEvent event) {
    final payloadJson = event.payloadJson;

    if (payloadJson != null && payloadJson.isNotEmpty) {
      ref
          .read(newOfferControllerProvider.notifier)
          .restoreFromNotificationPayload(payloadJson);
    }

    if (!mounted) return;

    context.go(AppRoutePaths.home);
  }

  void _handleAppResumed() {
    if (mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }

    unawaited(
      ref
          .read(availabilityProvider.notifier)
          .reconcileAvailabilityOnAppStartOrResume(),
    );
  }

  void _runAfterFirstFrame(FutureOr<void> Function() callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      unawaited(Future<void>.sync(callback));
    });
  }

  @override
  void dispose() {
    _restoreSubscription?.close();
    unawaited(_offerNotificationOpenSubscription?.cancel());

    _offerNotificationOpenSubscription = null;
    _appLifecycleListener?.dispose();
    _appLifecycleListener = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
