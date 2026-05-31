import 'package:bawabat_al_saeq/app/theme/app_colors.dart';
import 'package:bawabat_al_saeq/app/theme/app_theme_colors.dart';
import 'package:bawabat_al_saeq/app/theme/app_typography.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/features/trips/domain/entities/completed_period.dart';
import 'package:bawabat_al_saeq/features/trips/presentation/extensions/completed_period_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TripsFilterDropdown extends StatelessWidget {
  const TripsFilterDropdown({
    required this.value,
    required this.onChanged,
    this.enabled = true,
    super.key,
  });

  final CompletedPeriod value;
  final ValueChanged<CompletedPeriod?> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          for (final period in tripsVisiblePeriods) ...[
            _TripsFilterChip(
              label: period.label(context.l10n),
              selected: value == period,
              enabled: enabled,
              onTap: () => onChanged(period),
            ),
            if (period != tripsVisiblePeriods.last) SizedBox(width: 8.w),
          ],
        ],
      ),
    );
  }
}

class _TripsFilterChip extends StatelessWidget {
  const _TripsFilterChip({
    required this.label,
    required this.selected,
    required this.enabled,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = selected
        ? context.colors.primary
        : context.colors.surface;
    final borderColor = selected
        ? context.colors.primary
        : context.colors.border;
    final textColor = selected
        ? AppColors.textPrimary
        : context.colors.textPrimary;

    return Opacity(
      opacity: enabled ? 1 : 0.55,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(999.r),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            padding: EdgeInsets.symmetric(
              horizontal: 14.w,
              vertical: 10.h,
            ),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(999.r),
              border: Border.all(color: borderColor),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: context.colors.primary.withValues(alpha: 0.18),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ]
                  : null,
            ),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.labelMd.copyWith(
                color: textColor,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
