import 'package:bawabat_al_saeq/app/theme/app_theme_colors.dart';
import 'package:flutter/material.dart';

class AppCenteredLoading extends StatelessWidget {
  const AppCenteredLoading({
    this.verticalPadding = 24,
    this.strokeWidth = 3,
    super.key,
  });

  final double verticalPadding;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: verticalPadding),
        child: CircularProgressIndicator(
          color: context.colors.primary,
          strokeWidth: strokeWidth,
        ),
      ),
    );
  }
}
