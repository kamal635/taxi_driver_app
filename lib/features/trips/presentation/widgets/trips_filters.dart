import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/app/theme/app_typography.dart';
import 'package:taxi_driver_app/core/constants/app_icons.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';
import 'package:taxi_driver_app/features/trips/domain/entities/completed_offers_result_entity.dart';
import 'package:taxi_driver_app/l10n/app_localizations.dart';

extension CompletedPeriodX on CompletedPeriod {
  String label(AppLocalizations l10n) => switch (this) {
    CompletedPeriod.all => l10n.all,
    CompletedPeriod.day => l10n.day,
    CompletedPeriod.week => l10n.week,
    CompletedPeriod.month => l10n.month,
  };
}

class FilterDropdown extends StatelessWidget {
  const FilterDropdown({
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
