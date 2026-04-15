import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';
import 'package:taxi_driver_app/core/widgets/app_overlay_scaffold.dart';
import 'package:taxi_driver_app/features/app_update/presentation/widgets/app_update_status_card.dart';

class AppUpdatePage extends ConsumerWidget {
  const AppUpdatePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppOverlayScaffold(
      title: context.l10n.appUpdatePageTitle,
      child: const AppUpdateStatusCard(),
    );
  }
}
