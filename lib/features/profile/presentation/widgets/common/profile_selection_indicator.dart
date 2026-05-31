import 'package:bawabat_al_saeq/app/theme/app_theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileSelectionIndicator extends StatelessWidget {
  const ProfileSelectionIndicator({required this.isSelected, super.key});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 180),
      child: Icon(
        isSelected
            ? Icons.radio_button_checked_rounded
            : Icons.radio_button_unchecked_rounded,
        key: ValueKey<bool>(isSelected),
        size: 22.r,
        color: isSelected ? context.colors.primary : context.colors.iconMuted,
      ),
    );
  }
}
