import 'package:bawabat_al_saeq/app/theme/app_theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Shared rounded card surface used by feature screens.
///
/// Keeps card styling consistent across auth, profile, trips, and other
/// presentation widgets while still allowing small layout overrides.
class AppCardSurface extends StatelessWidget {
  const AppCardSurface({
    required this.child,
    this.padding,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.enableShadow = true,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderRadius;
  final bool enableShadow;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? 20.r;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor ?? context.colors.surface,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: borderColor ?? context.colors.border),
        boxShadow: enableShadow
            ? [
                BoxShadow(
                  blurRadius: 16.r,
                  offset: Offset(0, 8.h),
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
