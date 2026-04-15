import 'dart:async' show StreamSubscription, unawaited;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_driver_app/app/router/config/app_route_paths.dart';
import 'package:taxi_driver_app/app/router/route_names.dart';
import 'package:taxi_driver_app/features/app_update/presentation/dialogs/app_update_dialog.dart';
import 'package:taxi_driver_app/features/app_update/presentation/providers/app_update_providers.dart';
import 'package:taxi_driver_app/features/availability/data/datasources/android/driver_background_service_bridge.dart';
import 'package:taxi_driver_app/features/availability/presentation/controllers/availability_controller.dart';
import 'package:taxi_driver_app/features/availability/presentation/providers/availability_providers.dart';
import 'package:taxi_driver_app/features/home/domain/entities/current_and_pending_offer_entity.dart';
import 'package:taxi_driver_app/features/home/presentation/controllers/new_offer_controller.dart';
import 'package:taxi_driver_app/features/home/presentation/controllers/restore_current_controller.dart';
import 'package:taxi_driver_app/features/home/presentation/providers/offer_providers.dart';

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

  bool _hasBootstrappedUpdateCheck = false;

  @override
  void initState() {
    super.initState();

    _appLifecycleListener = AppLifecycleListener(
      onResume: _handleAppResumed,
    );

    _setupRestoreSubscription();
    _setupOfferNotificationListener();
    _bootstrapCurrentOfferRestore();
    _consumePendingOfferNotificationOpen();
    _bootstrapUpdateCheck();
  }

  void _setupRestoreSubscription() {
    _restoreSubscription = ref
        .listenManual<AsyncValue<CurrentAndPendingOfferEntity>>(
          restoreCurrentControllerProvider,
          (previous, next) {
            final restoredData = next.asData?.value;
            if (restoredData == null) {
              return;
            }

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final hasBootstrapped = ref.read(hasBootstrappedCurrentRestoreProvider);
      if (hasBootstrapped) {
        return;
      }

      ref.read(hasBootstrappedCurrentRestoreProvider.notifier).state = true;
      unawaited(ref.read(restoreCurrentControllerProvider.notifier).restore());
    });
  }

  void _consumePendingOfferNotificationOpen() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final pendingEvent = await ref
          .read(driverBackgroundServiceBridgeProvider)
          .consumePendingOfferNotificationOpen();

      if (!mounted || pendingEvent == null) {
        return;
      }

      _handleOfferNotificationOpen(pendingEvent);
    });
  }

  void _bootstrapUpdateCheck() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_checkForAppUpdate());
    });
  }

  Future<void> _checkForAppUpdate() async {
    if (_hasBootstrappedUpdateCheck) {
      return;
    }

    _hasBootstrappedUpdateCheck = true;

    final result = await ref.read(appUpdateStatusProvider.future);

    if (!mounted || !result.hasUpdate) {
      return;
    }

    final action = await showAppUpdateDialog(
      context: context,
      result: result,
    );

    if (!mounted || action != AppUpdateDialogAction.update) {
      return;
    }

    if (result.isForceUpdate) {
      return;
    }

    unawaited(
      ref
          .read(appUpdateFlowControllerProvider.notifier)
          .startOptionalUpdate(result),
    );

    if (!mounted) {
      return;
    }

    await context.pushNamed(RouteNames.profileAppUpdate);
  }

  void _handleOfferNotificationOpen(DriverOfferNotificationOpenEvent event) {
    final payloadJson = event.payloadJson;
    if (payloadJson != null && payloadJson.isNotEmpty) {
      ref
          .read(newOfferControllerProvider.notifier)
          .restoreFromNotificationPayload(payloadJson);
    }

    if (!mounted) {
      return;
    }

    context.go(AppRoutePaths.home);
  }

  void _handleAppResumed() {
    if (mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }

    final flowState = ref.read(appUpdateFlowControllerProvider);
    if (flowState.hiddenVersionCode != null) {
      ref.read(appUpdateFlowControllerProvider.notifier).clearInstallerHint();
      unawaited(ref.read(appUpdateStatusProvider.notifier).refreshStatus());
    }

    unawaited(
      ref
          .read(availabilityProvider.notifier)
          .reconcileAvailabilityOnAppStartOrResume(),
    );
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
