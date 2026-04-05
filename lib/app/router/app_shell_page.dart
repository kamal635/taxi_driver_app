import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_driver_app/app/router/app_routes.dart';
import 'package:taxi_driver_app/app/router/widgets/app_top_bar.dart';
import 'package:taxi_driver_app/app/router/widgets/bottom_nav.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';
import 'package:taxi_driver_app/features/availability/presentation/controllers/availability_controller.dart';
import 'package:taxi_driver_app/features/home/domain/entities/current_and_pending_offer_entity.dart';
import 'package:taxi_driver_app/features/home/presentation/controllers/restore_current_controller.dart';
import 'package:taxi_driver_app/features/home/presentation/providers/offer_providers.dart';

class AppShellPage extends ConsumerStatefulWidget {
  const AppShellPage({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<AppShellPage> createState() => _AppShellPageState();
}

class _AppShellPageState extends ConsumerState<AppShellPage> {
  AppLifecycleListener? _appLifecycleListener;
  ProviderSubscription<AsyncValue<CurrentAndPendingOfferEntity>>?
  _restoreSubscription;

  @override
  void initState() {
    super.initState();
    _setupLifecycleListener();
    _setupRestoreSubscription();
    _bootstrapCurrentOfferRestore();
  }

  void _setupLifecycleListener() {
    _appLifecycleListener = AppLifecycleListener(onResume: _handleAppResumed);
  }

  void _setupRestoreSubscription() {
    _restoreSubscription = ref
        .listenManual<AsyncValue<CurrentAndPendingOfferEntity>>(
          restoreCurrentControllerProvider,
          (previous, next) {
            final data = next.asData?.value;
            if (data == null) return;

            ref.read(restoredCurrentOfferProvider.notifier).state =
                data.currentOffer;
          },
        );
  }

  void _bootstrapCurrentOfferRestore() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final didBootstrap = ref.read(hasBootstrappedCurrentRestoreProvider);
      if (didBootstrap) return;

      ref.read(hasBootstrappedCurrentRestoreProvider.notifier).state = true;
      unawaited(ref.read(restoreCurrentControllerProvider.notifier).restore());
    });
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

  String _pageTitle(BuildContext context) {
    final l10n = context.l10n;

    return switch (widget.navigationShell.currentIndex) {
      0 => l10n.navHome,
      1 => l10n.navTrips,
      _ => l10n.navProfile,
    };
  }

  @override
  void dispose() {
    _restoreSubscription?.close();
    _appLifecycleListener?.dispose();
    _appLifecycleListener = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  AppSpacing.h8,
                  AppTopBar(
                    title: _pageTitle(context),
                    onAvatarPressed: () => context.go(AppRoutes.profile),
                  ),
                  AppSpacing.h8,
                ],
              ),
            ),
            Expanded(child: widget.navigationShell),
          ],
        ),
      ),
      bottomNavigationBar: BottomNav(
        index: widget.navigationShell.currentIndex,
        onChanged: widget.navigationShell.goBranch,
        homeLabel: l10n.navHome,
        tripsLabel: l10n.navTrips,
        profileLabel: l10n.navProfile,
      ),
    );
  }
}
