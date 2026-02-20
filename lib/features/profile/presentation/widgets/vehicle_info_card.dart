import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/app/theme/app_typography.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';
import 'package:taxi_driver_app/features/profile/presentation/widgets/vehicle_info_item.dart';
import 'package:taxi_driver_app/features/profile/presentation/widgets/vehicle_info_page.dart';

class VehicleCard extends StatelessWidget {
  const VehicleCard({
    required this.vehicle,
    super.key,
  });

  final VehicleModel vehicle;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final items = [
      VehicleInfoItem(
        icon: Icons.confirmation_number_rounded,
        label: l10n.vehiclePlateNumberLabel,
        value: vehicle.plateNumber,
      ),

      VehicleInfoItem(
        icon: Icons.lightbulb_outline_rounded,
        label: l10n.vehicleTaxiLanternNumberLabel,
        value: vehicle.taxiLanternNumber,
      ),

      VehicleInfoItem(
        icon: Icons.directions_car_rounded,
        label: l10n.vehicleModelLabel,
        value: vehicle.model,
      ),

      VehicleInfoItem(
        icon: Icons.category_rounded,
        label: l10n.vehicleTypeLabel,
        value: vehicle.type.label,
      ),
    ];
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 10),
            color: AppColors.textPrimary.withValues(alpha: 0.06),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...items.map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: VehicleInfoItem(
                icon: item.icon,
                label: item.label,
                value: item.value,
              ),
            ),
          ),

          const Divider(color: AppColors.border),
          AppSpacing.h10,
          Text(
            l10n.vehicleInfoNote,
            style: AppTypography.subtitleSm,
          ),
        ],
      ),
    );
  }
}
