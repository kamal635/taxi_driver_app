import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/app/theme/app_typography.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({
    required this.index,
    required this.onChanged,
    required this.homeLabel,
    required this.tripsLabel,
    required this.profileLabel,
    super.key,
  });

  final int index;
  final ValueChanged<int> onChanged;

  final String homeLabel;
  final String tripsLabel;
  final String profileLabel;

  @override
  Widget build(BuildContext context) {
    final items = <_NavItemData>[
      _NavItemData(icon: Icons.home_rounded, label: homeLabel),
      _NavItemData(icon: Icons.directions_car_rounded, label: tripsLabel),
      _NavItemData(icon: Icons.person_rounded, label: profileLabel),
    ];

    return Container(
      padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(color: AppColors.border)),
        boxShadow: [
          BoxShadow(
            blurRadius: 22,
            offset: const Offset(0, -10),
            color: Colors.black.withValues(alpha: 0.06),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (i) {
          final data = items[i];
          final selected = i == index;

          return InkWell(
            borderRadius: BorderRadius.circular(18.r),
            onTap: () => onChanged(i),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 46.r,
                    height: 46.r,
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.taxiYellow
                          : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      data.icon,
                      size: 22.r,
                      color: selected
                          ? AppColors.textPrimary
                          : AppColors.iconMuted,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    data.label,
                    style: AppTypography.labelSm.copyWith(
                      fontWeight: selected ? FontWeight.w900 : FontWeight.w700,
                      color: selected
                          ? AppColors.textPrimary
                          : AppColors.iconMuted,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _NavItemData {
  const _NavItemData({required this.icon, required this.label});
  final IconData icon;
  final String label;
}
