import 'package:bawabat_al_saeq/app/theme/app_colors.dart';
import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/app/theme/app_typography.dart';
import 'package:bawabat_al_saeq/shared/presentation/widgets/surfaces/app_card_surface.dart';
import 'package:flutter/material.dart';

/// A titled group of profile actions.
class ProfileSection extends StatelessWidget {
  const ProfileSection({
    required this.title,
    required this.children,
    super.key,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.subtitleSm.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w900,
          ),
        ),
        AppSpacing.h10,
        AppCardSurface(
          padding: EdgeInsets.zero,
          child: Column(children: children),
        ),
      ],
    );
  }
}
