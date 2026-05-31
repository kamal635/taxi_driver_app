import 'package:bawabat_al_saeq/app/theme/app_theme_colors.dart';
import 'package:bawabat_al_saeq/features/home/presentation/widgets/empty/home_empty_icon_core.dart';
import 'package:bawabat_al_saeq/features/home/presentation/widgets/empty/home_empty_icon_frame.dart';
import 'package:bawabat_al_saeq/features/home/presentation/widgets/empty/home_empty_state_circle_layer.dart';
import 'package:flutter/material.dart';

/// Static indicator used when the driver is offline and no search is running.
class StaticHomeEmptyStateIcon extends StatelessWidget {
  const StaticHomeEmptyStateIcon({required this.icon, super.key});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return HomeEmptyIconFrame(
      builder: (context, metrics) {
        return Stack(
          alignment: Alignment.center,
          children: [
            HomeEmptyStateCircleLayer(
              size: metrics.baseSize,
              color: colors.surfaceMuted.withValues(alpha: 0.72),
              borderColor: colors.border,
            ),
            HomeEmptyIconCore(
              icon: icon,
              iconColor: colors.iconMuted,
              surfaceColor: colors.surface.withValues(alpha: 0.90),
              shadowColor: colors.shadow,
              size: metrics.innerSize,
            ),
          ],
        );
      },
    );
  }
}
