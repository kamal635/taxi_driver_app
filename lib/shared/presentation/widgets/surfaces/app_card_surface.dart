import 'package:bawabat_al_saeq/app/theme/app_theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Shared rounded card surface used by feature screens.
///
/// The defaults match the common app card style. The optional shadow and size
/// parameters cover home/trips/profile variants without creating local wrapper
/// widgets for every feature.
class AppCardSurface extends StatelessWidget {
  const AppCardSurface({
    required this.child,
    this.padding,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.enableShadow = true,
    this.shadowBlurRadius,
    this.shadowOffset,
    this.width,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderRadius;
  final bool enableShadow;
  final double? shadowBlurRadius;
  final Offset? shadowOffset;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? 20.r;

    return Container(
      width: width,
      decoration: BoxDecoration(
        color: backgroundColor ?? context.colors.surface,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: borderColor ?? context.colors.border),
        boxShadow: enableShadow
            ? [
                BoxShadow(
                  blurRadius: shadowBlurRadius ?? 16.r,
                  offset: shadowOffset ?? Offset(0, 8.h),
                  color: context.colors.shadow,
                ),
              ]
            : null,
      ),
      child: Padding(
        padding: padding ?? EdgeInsets.all(16.r),
        child: child,
      ),
    );
  }
}
