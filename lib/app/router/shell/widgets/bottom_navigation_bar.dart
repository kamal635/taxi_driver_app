import 'package:bawabat_al_saeq/app/theme/app_theme_colors.dart';
import 'package:bawabat_al_saeq/app/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    final colors = context.colors;

    final items = <_NavItemData>[
      _NavItemData(icon: Icons.home_rounded, label: homeLabel),
      _NavItemData(icon: Icons.directions_car_rounded, label: tripsLabel),
      _NavItemData(icon: Icons.person_rounded, label: profileLabel),
    ];

    return SafeArea(
      top: false,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          border: Border(top: BorderSide(color: colors.border)),
          boxShadow: [
            BoxShadow(
              blurRadius: 18,
              offset: const Offset(0, -8),
              color: colors.shadow,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 4.h),
          child: Row(
            children: List.generate(items.length, (itemIndex) {
              final item = items[itemIndex];
              final isSelected = itemIndex == index;

              return Expanded(
                child: _BottomNavItem(
                  data: item,
                  isSelected: isSelected,
                  onTap: isSelected ? null : () => onChanged(itemIndex),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.data,
    required this.isSelected,
    required this.onTap,
  });

  final _NavItemData data;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final color = isSelected ? colors.primary : colors.iconMuted;

    return Semantics(
      button: true,
      selected: isSelected,
      label: data.label,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 54.h,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(data.icon, size: 24.r, color: color),
                  SizedBox(height: 6.h),
                  Text(
                    data.label,
                    style: AppTypography.labelSm.copyWith(
                      color: color,
                      fontWeight: isSelected
                          ? FontWeight.w800
                          : FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOutCubic,
                  height: 2.h,
                  width: isSelected ? 36.w : 0,
                  decoration: BoxDecoration(
                    color: colors.primary,
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItemData {
  const _NavItemData({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;
}
