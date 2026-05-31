import 'package:bawabat_al_saeq/app/theme/app_typography.dart';
import 'package:flutter/material.dart';

class AvatarFallbackText extends StatelessWidget {
  const AvatarFallbackText({required this.initial, super.key});

  final String initial;

  @override
  Widget build(BuildContext context) {
    return Text(
      initial,
      style: AppTypography.titleSm.copyWith(fontWeight: FontWeight.w900),
    );
  }
}
