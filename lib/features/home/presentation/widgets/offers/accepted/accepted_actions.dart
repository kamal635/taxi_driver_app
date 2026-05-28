import 'package:bawabat_al_saeq/app/theme/app_colors.dart';
import 'package:bawabat_al_saeq/app/theme/app_theme_colors.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/core/widgets/app_button.dart';
import 'package:flutter/material.dart';

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
    final colors = context.colors;

    return AppButton(
      isLoading: isCompletedLoading,
      backgroundColor: canComplete ? colors.primary : colors.border,
      labelColor: canComplete ? AppColors.textPrimary : colors.iconMuted,
      label: canComplete ? l10n.tripCompleted : l10n.tripProgress,
      onPressed: canComplete ? onComplete : null,
    );
  }
}
