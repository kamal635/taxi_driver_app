import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';

class AppBackground extends StatelessWidget {
  const AppBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.bgWarm,
      child: Stack(
        children: [
          _softCircle(top: -40.h, start: -30.w, size: 220.r, opacity: 0.08),
          _softCircle(top: 160.h, end: -60.w, size: 260.r, opacity: 0.06),
          _softCircle(bottom: 120.h, start: 10.w, size: 200.r, opacity: 0.06),
        ],
      ),
    );
  }

  /// A soft blurry circle used for decorative purposes in the background.
  Widget _softCircle({
    required double size,
    required double opacity,
    double? top,
    double? bottom,
    double? start,
    double? end,
  }) {
    return PositionedDirectional(
      top: top,
      bottom: bottom,
      start: start,
      end: end,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primary.withValues(alpha: opacity),
        ),
      ),
    );
  }
}
