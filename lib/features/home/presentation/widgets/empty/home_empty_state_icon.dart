import 'package:bawabat_al_saeq/features/home/presentation/widgets/empty/pulsing_home_empty_state_icon.dart';
import 'package:bawabat_al_saeq/features/home/presentation/widgets/empty/static_home_empty_state_icon.dart';
import 'package:flutter/material.dart';

class HomeEmptyStateIcon extends StatelessWidget {
  const HomeEmptyStateIcon({
    required this.icon,
    required this.animate,
    super.key,
  });

  final IconData icon;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    if (animate) {
      return PulsingHomeEmptyStateIcon(icon: icon);
    }

    return StaticHomeEmptyStateIcon(icon: icon);
  }
}
