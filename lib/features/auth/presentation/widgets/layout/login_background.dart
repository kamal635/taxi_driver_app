import 'package:bawabat_al_saeq/app/theme/app_theme_colors.dart';
import 'package:flutter/material.dart';

class LoginBackground extends StatelessWidget {
  const LoginBackground({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topCenter,
          radius: 1.5,
          colors: [colors.backgroundDecorative, colors.background],
        ),
      ),
      child: child,
    );
  }
}
