import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/app/theme/app_theme_colors.dart';
import 'package:bawabat_al_saeq/app/theme/app_typography.dart';
import 'package:bawabat_al_saeq/shared/presentation/widgets/buttons/app_button.dart';
import 'package:bawabat_al_saeq/shared/presentation/widgets/surfaces/app_card_surface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onActionPressed,
    this.isActionLoading = false,
    this.useCard = false,
    this.iconSize = 96,
    super.key,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onActionPressed;
  final bool isActionLoading;
  final bool useCard;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _AppEmptyStateIcon(icon: icon, size: iconSize),
        AppSpacing.h12,
        Text(
          title,
          style: AppTypography.titleSm,
          textAlign: TextAlign.center,
        ),
        AppSpacing.h8,
        Text(
          subtitle,
          style: AppTypography.bodyMuted,
          textAlign: TextAlign.center,
        ),
        if (actionLabel != null) ...[
          AppSpacing.h18,
          AppButton(
            label: actionLabel!,
            onPressed: onActionPressed,
            isLoading: isActionLoading,
          ),
        ],
      ],
    );

    if (!useCard) {
      return content;
    }

    return AppCardSurface(child: content);
  }
}

class _AppEmptyStateIcon extends StatelessWidget {
  const _AppEmptyStateIcon({
    required this.icon,
    required this.size,
  });

  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.r,
      height: size.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: context.colors.primary.withValues(alpha: 0.14),
        border: Border.all(
          color: context.colors.primary.withValues(alpha: 0.30),
        ),
      ),
      child: Icon(
        icon,
        size: (size * 0.36).r,
        color: context.colors.textPrimary,
      ),
    );
  }
}
