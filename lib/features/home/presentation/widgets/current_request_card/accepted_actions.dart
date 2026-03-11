import 'package:flutter/material.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';
import 'package:taxi_driver_app/core/widgets/app_button.dart';

class AcceptedActions extends StatelessWidget {
  const AcceptedActions({
    required this.canComplete,
    this.actionCompletedOffer,
    super.key,
  });

  final bool canComplete;
  final VoidCallback? actionCompletedOffer;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppButton(
      backgroundColor: canComplete ? AppColors.primary : AppColors.border,
      labelColor: canComplete ? AppColors.textPrimary : AppColors.iconMuted,
      label: canComplete ? l10n.tripCompleted : l10n.tripProgress,
      onPressed: canComplete ? actionCompletedOffer : null,
    );
  }
}
