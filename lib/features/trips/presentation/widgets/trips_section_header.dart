import 'package:flutter/material.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/app/theme/app_typography.dart';

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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          title,
          style: AppTypography.titleSm,
        ),
        AppSpacing.w8,
        Expanded(
          child: Text(
            subtitle,
            style: AppTypography.subtitleSm,
          ),
        ),
      ],
    );
  }
}
