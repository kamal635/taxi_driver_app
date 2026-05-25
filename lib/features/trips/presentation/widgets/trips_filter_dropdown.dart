import 'package:bawabat_al_saeq/app/theme/app_colors.dart';
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<CompletedPeriod>(
          value: value,
          dropdownColor: AppColors.white,
          borderRadius: BorderRadius.circular(14.r),
          icon: const Icon(AppIcons.arrowDown),
          style: AppTypography.labelMd,
          onChanged: enabled ? onChanged : null,
          items: CompletedPeriod.values.map((period) {
            return DropdownMenuItem<CompletedPeriod>(
              value: period,
              child: Text(period.label(context.l10n)),
            );
          }).toList(),
        ),
      ),
    );
  }
}
