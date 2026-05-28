import 'package:bawabat_al_saeq/app/theme/app_theme_colors.dart';
import 'package:flutter/material.dart';

class TripsLoadingState extends StatelessWidget {
  const TripsLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: CircularProgressIndicator(
          color: context.colors.primary,
          strokeWidth: 3,
        ),
      ),
    );
  }
}
