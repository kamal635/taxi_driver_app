import 'package:flutter/material.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';
import 'package:taxi_driver_app/core/widgets/app_button.dart';

/// Action button shown for an accepted offer.
class AcceptedActions extends StatelessWidget {
  const AcceptedActions({
    required this.canComplete,
    required this.isCompletedLoading,
    this.onComplete,
    super.key,
  });

  final bool canComplete;
  final bool isCompletedLoading;
  final VoidCallback? onComplete;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppButton(
      isLoading: isCompletedLoading,
      backgroundColor: canComplete ? AppColors.primary : AppColors.border,
      labelColor: canComplete ? AppColors.textPrimary : AppColors.iconMuted,
      label: canComplete ? l10n.tripCompleted : l10n.tripProgress,
      onPressed: canComplete ? onComplete : null,
    );
  }
}
