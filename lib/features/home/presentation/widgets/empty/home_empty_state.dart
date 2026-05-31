import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/app/theme/app_typography.dart';
import 'package:bawabat_al_saeq/features/home/presentation/widgets/empty/home_empty_state_icon.dart';
import 'package:bawabat_al_saeq/shared/presentation/widgets/buttons/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Empty state shown when there is no pending or active offer.
class HomeEmptyState extends StatelessWidget {
  const HomeEmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.animateIcon = true,
    this.actionLabel,
    this.onActionPressed,
    this.isActionLoading = false,
    super.key,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  /// Whether the icon should pulse to indicate active request searching.
  ///
  /// This should be false when the driver is offline, because no request
  /// searching is running in that state.
  final bool animateIcon;

  /// Optional action shown below the subtitle.
  ///
  /// Used for the offline state to let the driver enable availability directly.
  final String? actionLabel;
  final VoidCallback? onActionPressed;
  final bool isActionLoading;

  @override
  Widget build(BuildContext context) {
    final hasAction = actionLabel != null;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        HomeEmptyStateIcon(icon: icon, animate: animateIcon),
        AppSpacing.h18,
        Text(
          title,
          textAlign: TextAlign.center,
          style: AppTypography.titleSm,
        ),
        AppSpacing.h10,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 22.w),
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: AppTypography.bodyMuted,
          ),
        ),
        if (hasAction) ...[
          AppSpacing.h24,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 42.w),
            child: AppButton(
              label: actionLabel!,
              onPressed: onActionPressed,
              isLoading: isActionLoading,
            ),
          ),
        ],
      ],
    );
  }
}
