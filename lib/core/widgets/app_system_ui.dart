import 'package:bawabat_al_saeq/app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Keeps Android system bars aligned with the app background.
///
/// On Android 15+ apps targeting SDK 35 run edge-to-edge by default. In that
/// mode the navigation bar is effectively transparent, so the visible color
/// comes from the widget behind it. This wrapper makes the background stable
/// across route changes and hot restarts.
class AppSystemUi extends StatelessWidget {
  const AppSystemUi({
    required this.child,
    super.key,
    this.backgroundColor = AppColors.bgBase,
    this.statusBarIconBrightness = Brightness.dark,
    this.navigationBarIconBrightness = Brightness.dark,
  });

  final Widget child;
  final Color backgroundColor;
  final Brightness statusBarIconBrightness;
  final Brightness navigationBarIconBrightness;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        statusBarIconBrightness: statusBarIconBrightness,
        systemNavigationBarIconBrightness: navigationBarIconBrightness,
        systemNavigationBarContrastEnforced: false,
      ),
      child: ColoredBox(
        color: backgroundColor,
        child: child,
      ),
    );
  }
}
