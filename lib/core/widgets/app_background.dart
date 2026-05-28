import 'package:bawabat_al_saeq/app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Decorative background used behind the main app content.
class AppBackground extends StatelessWidget {
  const AppBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return const RepaintBoundary(
      child: ColoredBox(
        color: AppColors.bgWarm,
        child: Stack(
          children: [
            _BackgroundCircle(
              top: -40,
              start: -30,
              size: 220,
              opacity: 0.08,
            ),
            _BackgroundCircle(
              top: 160,
              end: -60,
              size: 260,
              opacity: 0.06,
            ),
            _BackgroundCircle(
              bottom: 120,
              start: 10,
              size: 200,
              opacity: 0.06,
            ),
          ],
        ),
      ),
    );
  }
}

class _BackgroundCircle extends StatelessWidget {
  const _BackgroundCircle({
    required this.size,
    required this.opacity,
    this.top,
    this.bottom,
    this.start,
    this.end,
  });

  final double size;
  final double opacity;
  final double? top;
  final double? bottom;
  final double? start;
  final double? end;

  @override
  Widget build(BuildContext context) {
    return PositionedDirectional(
      top: top?.h,
      bottom: bottom?.h,
      start: start?.w,
      end: end?.w,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primary.withValues(alpha: opacity),
        ),
        child: SizedBox.square(dimension: size.r),
      ),
    );
  }
}
