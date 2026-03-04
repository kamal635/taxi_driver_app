import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/app/theme/app_typography.dart';
import 'package:taxi_driver_app/features/trips/presentation/pages/trips_page.dart';

class TripsFilters extends StatelessWidget {
  const TripsFilters({
    required this.selected,
    required this.allLabel,
    required this.todayLabel,
    required this.weekLabel,
    required this.onChanged,
    super.key,
  });

  final TripsFilterUi selected;
  final String allLabel;
  final String todayLabel;
  final String weekLabel;
  final ValueChanged<TripsFilterUi> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _FilterChipButton(
            label: allLabel,
            selected: selected == TripsFilterUi.all,
            onTap: () => onChanged(TripsFilterUi.all),
          ),
        ),

        AppSpacing.w12,

        Expanded(
          child: _FilterChipButton(
            label: todayLabel,
            selected: selected == TripsFilterUi.today,
            onTap: () => onChanged(TripsFilterUi.today),
          ),
        ),

        AppSpacing.w12,

        Expanded(
          child: _FilterChipButton(
            label: weekLabel,
            selected: selected == TripsFilterUi.week,
            onTap: () => onChanged(TripsFilterUi.week),
          ),
        ),
      ],
    );
  }
}

class _FilterChipButton extends StatelessWidget {
  const _FilterChipButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bg = selected ? AppColors.primary : Colors.white;
    final borderColor = selected ? Colors.transparent : AppColors.border;

    return InkWell(
      borderRadius: BorderRadius.circular(14.r),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: borderColor),
          boxShadow: selected
              ? [
                  BoxShadow(
                    blurRadius: 16,
                    offset: const Offset(0, 10),
                    color: AppColors.primary.withValues(alpha: 0.22),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: AppTypography.labelMd.copyWith(
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
