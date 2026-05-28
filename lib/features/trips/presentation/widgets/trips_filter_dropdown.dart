import 'package:bawabat_al_saeq/app/theme/app_theme_colors.dart';
import 'package:bawabat_al_saeq/app/theme/app_typography.dart';
import 'package:bawabat_al_saeq/core/constants/app_icons.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/features/trips/domain/entities/completed_offers_result_entity.dart';
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
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: context.colors.border),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.only(
          start: 14.w,
          end: 10.w,
        ),
        child: SizedBox(
          height: 44.h,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<CompletedPeriod>(
              value: value,
              dropdownColor: context.colors.surface,
              borderRadius: BorderRadius.circular(14.r),
              icon: Icon(
                AppIcons.arrowDown,
                size: 22.r,
                color: context.colors.iconMuted,
              ),
              style: AppTypography.labelMd.copyWith(
                color: context.colors.textPrimary,
                height: 1.2,
              ),
              alignment: AlignmentDirectional.center,
              onChanged: enabled ? onChanged : null,
              items: CompletedPeriod.values.map((period) {
                return DropdownMenuItem<CompletedPeriod>(
                  value: period,
                  child: Text(
                    period.label(context.l10n),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
