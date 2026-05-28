import 'dart:async' show unawaited;

import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/app/theme/app_theme_colors.dart';
import 'package:bawabat_al_saeq/app/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Empty state shown when there is no pending or active offer.
class HomeEmptyState extends StatelessWidget {
  const HomeEmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.animateIcon = true,
    super.key,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  /// Whether the icon should pulse to indicate active request searching.
  ///
  /// This should be false when the driver is offline, because no request
  /// searching is running in that state.
  final bool animateIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (animateIcon)
          _PulsingEmptyStateIcon(icon: icon)
        else
          _StaticEmptyStateIcon(icon: icon),
        AppSpacing.h18,
        Text(
          title,
          textAlign: TextAlign.center,
          style: AppTypography.titleSm,
        ),
        AppSpacing.h10,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 22.w),
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: AppTypography.bodyMuted,
          ),
        ),
      ],
    );
  }
}

/// Soft pulsing indicator used while the driver is waiting for new requests.
class _PulsingEmptyStateIcon extends StatefulWidget {
  const _PulsingEmptyStateIcon({
    required this.icon,
  });

  final IconData icon;

  @override
  State<_PulsingEmptyStateIcon> createState() => _PulsingEmptyStateIconState();
}

class _PulsingEmptyStateIconState extends State<_PulsingEmptyStateIcon>
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
    final outerSize = 190.r;
    final baseSize = 136.r;
    final innerSize = 86.r;

    return RepaintBoundary(
      child: SizedBox.square(
        dimension: outerSize,
        child: AnimatedBuilder(
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
                    child: _CircleLayer(
                      size: baseSize,
                      color: colors.primary.withValues(alpha: 0.20),
                      borderColor: colors.primary.withValues(alpha: 0.32),
                    ),
                  ),
                ),
                Transform.scale(
                  scale: centerScale,
                  child: _CircleLayer(
                    size: baseSize,
                    color: colors.primary.withValues(alpha: 0.10),
                    borderColor: colors.primary.withValues(alpha: 0.22),
                  ),
                ),
                Transform.scale(
                  scale: centerScale,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colors.surface.withValues(alpha: 0.84),
                      boxShadow: [
                        BoxShadow(
                          color: colors.shadow,
                          blurRadius: 24.r,
                          offset: Offset(0, 10.h),
                        ),
                      ],
                    ),
                    child: SizedBox.square(
                      dimension: innerSize,
                      child: Icon(
                        widget.icon,
                        size: 38.r,
                        color: colors.textPrimary.withValues(alpha: 0.88),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Static indicator used when the driver is offline and no search is running.
class _StaticEmptyStateIcon extends StatelessWidget {
  const _StaticEmptyStateIcon({
    required this.icon,
  });

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final outerSize = 190.r;
    final baseSize = 136.r;
    final innerSize = 86.r;

    return SizedBox.square(
      dimension: outerSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _CircleLayer(
            size: baseSize,
            color: colors.surfaceMuted.withValues(alpha: 0.72),
            borderColor: colors.border,
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.surface.withValues(alpha: 0.90),
              boxShadow: [
                BoxShadow(
                  color: colors.shadow,
                  blurRadius: 18.r,
                  offset: Offset(0, 8.h),
                ),
              ],
            ),
            child: SizedBox.square(
              dimension: innerSize,
              child: Icon(
                icon,
                size: 38.r,
                color: colors.iconMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleLayer extends StatelessWidget {
  const _CircleLayer({
    required this.size,
    required this.color,
    required this.borderColor,
  });

  final double size;
  final Color color;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(
          color: borderColor,
          width: 1.2,
        ),
      ),
    );
  }
}
