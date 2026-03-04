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

    // ✅ ألوان مثل Sofascore-style (بس مع لمسة الـ brand عندك)
    const inactiveColor = AppColors.iconMuted;
    const activeColor = AppColors.primary; // بدك إياها أزرق؟ بقلك تحت
    const indicatorColor = AppColors.primary;

    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.only(top: 4.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: const Border(top: BorderSide(color: AppColors.border)),
          boxShadow: [
            BoxShadow(
              blurRadius: 18,
              offset: const Offset(0, -8),
              color: Colors.black.withValues(alpha: 0.06),
            ),
          ],
        ),
        child: Row(
          children: List.generate(items.length, (i) {
            final data = items[i];
            final selected = i == index;

            return Expanded(
              child: InkWell(
                onTap: () => onChanged(i),
                child: SizedBox(
                  height: 54.h,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Content (Icon + Text)
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            data.icon,
                            size: 24.r,
                            color: selected ? activeColor : inactiveColor,
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            data.label,
                            style: AppTypography.labelSm.copyWith(
                              color: selected ? activeColor : inactiveColor,
                              fontWeight: selected
                                  ? FontWeight.w800
                                  : FontWeight.w600,
                            ),
                          ),
                        ],
                      ),

                      // ✅ Indicator line under selected tab
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          curve: Curves.easeOutCubic,
                          height: 2.h,
                          width: selected ? 36.w : 0,
                          margin: EdgeInsets.only(bottom: 0.h),
                          decoration: BoxDecoration(
                            color: indicatorColor,
                            borderRadius: BorderRadius.circular(999.r),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _NavItemData {
  const _NavItemData({required this.icon, required this.label});
  final IconData icon;
  final String label;
}
