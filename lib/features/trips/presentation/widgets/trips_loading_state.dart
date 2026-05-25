import 'package:bawabat_al_saeq/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class TripsLoadingState extends StatelessWidget {
  const TripsLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: CircularProgressIndicator(
          color: AppColors.primary,
          strokeWidth: 3,
        ),
      ),
    );
  }
}
