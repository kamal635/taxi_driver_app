import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/app/theme/app_typography.dart';
import 'package:flutter/material.dart';

class TripsSectionHeader extends StatelessWidget {
  const TripsSectionHeader({
    required this.title,
    required this.subtitle,
    super.key,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.titleSm,
        ),
        AppSpacing.h10,
        Text(
          subtitle,
          style: AppTypography.subtitleSm,
        ),
      ],
    );
  }
}
