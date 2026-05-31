import 'dart:async' show unawaited;

import 'package:bawabat_al_saeq/app/theme/app_theme_colors.dart';
import 'package:bawabat_al_saeq/features/home/presentation/widgets/empty/home_empty_icon_core.dart';
import 'package:bawabat_al_saeq/features/home/presentation/widgets/empty/home_empty_icon_frame.dart';
import 'package:bawabat_al_saeq/features/home/presentation/widgets/empty/home_empty_state_circle_layer.dart';
import 'package:flutter/material.dart';

/// Soft pulsing indicator used while the driver is waiting for new requests.
class PulsingHomeEmptyStateIcon extends StatefulWidget {
  const PulsingHomeEmptyStateIcon({required this.icon, super.key});

  final IconData icon;

  @override
  State<PulsingHomeEmptyStateIcon> createState() =>
      _PulsingHomeEmptyStateIconState();
}

class _PulsingHomeEmptyStateIconState extends State<PulsingHomeEmptyStateIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    unawaited(_controller.repeat(reverse: true));

    _pulse = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: HomeEmptyIconFrame(
        builder: (context, metrics) {
          return AnimatedBuilder(
            animation: _pulse,
            builder: (context, child) {
              final colors = context.colors;
              final progress = _pulse.value;
              final pulseScale = 0.68 + (progress * 0.58);
              final pulseOpacity = 0.10 + (progress * 0.24);
              final centerScale = 0.96 + (progress * 0.06);

              return Stack(
                alignment: Alignment.center,
                children: [
                  Opacity(
                    opacity: pulseOpacity,
                    child: Transform.scale(
                      scale: pulseScale,
                      child: HomeEmptyStateCircleLayer(
                        size: metrics.baseSize,
                        color: colors.primary.withValues(alpha: 0.20),
                        borderColor: colors.primary.withValues(alpha: 0.32),
                      ),
                    ),
                  ),
                  Transform.scale(
                    scale: centerScale,
                    child: HomeEmptyStateCircleLayer(
                      size: metrics.baseSize,
                      color: colors.primary.withValues(alpha: 0.10),
                      borderColor: colors.primary.withValues(alpha: 0.22),
                    ),
                  ),
                  Transform.scale(
                    scale: centerScale,
                    child: HomeEmptyIconCore(
                      icon: widget.icon,
                      iconColor: colors.textPrimary.withValues(alpha: 0.88),
                      surfaceColor: colors.surface.withValues(alpha: 0.84),
                      shadowColor: colors.shadow,
                      size: metrics.innerSize,
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
