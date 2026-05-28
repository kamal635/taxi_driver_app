import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/app/theme/app_theme_colors.dart';
import 'package:bawabat_al_saeq/app/theme/app_typography.dart';
import 'package:bawabat_al_saeq/features/trips/presentation/widgets/trips_card_surface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TripsEmptyState extends StatelessWidget {
  const TripsEmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
    super.key,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return TripsCardSurface(
      child: Column(
        children: [
          Container(
            width: 96.r,
            height: 96.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.colors.primary.withValues(alpha: 0.14),
              border: Border.all(
                color: context.colors.primary.withValues(alpha: 0.30),
              ),
            ),
            child: Icon(
              icon,
              size: 34.r,
              color: context.colors.textPrimary,
            ),
          ),
          AppSpacing.h12,
          Text(
            title,
            style: AppTypography.titleSm,
            textAlign: TextAlign.center,
          ),
          AppSpacing.h8,
          Text(
            subtitle,
            style: AppTypography.subtitleMd,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
