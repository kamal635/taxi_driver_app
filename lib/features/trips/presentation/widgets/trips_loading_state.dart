import 'package:flutter/material.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';

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
