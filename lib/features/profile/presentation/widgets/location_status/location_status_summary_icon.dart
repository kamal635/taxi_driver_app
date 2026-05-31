import 'package:bawabat_al_saeq/app/theme/app_theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LocationStatusSummaryIcon extends StatelessWidget {
  const LocationStatusSummaryIcon({required this.isReady, super.key});

  final bool isReady;

  @override
  Widget build(BuildContext context) {
    final color = isReady ? context.colors.success : context.colors.error;
    final backgroundColor = isReady
        ? context.colors.successBg
        : context.colors.errorBg;

    return Container(
      width: 42.r,
      height: 42.r,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        border: Border.all(color: context.colors.border),
      ),
      child: Icon(
        isReady ? Icons.verified_rounded : Icons.warning_rounded,
        color: color,
        size: 22.r,
      ),
    );
  }
}
