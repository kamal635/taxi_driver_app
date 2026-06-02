import 'package:bawabat_al_saeq/app/theme/app_theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Soft internal separator for the offer content.
///
/// It keeps the offer as one visual surface instead of creating many nested
/// cards inside the main card.
class OfferSectionDivider extends StatelessWidget {
  const OfferSectionDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      child: Divider(
        height: 1.h,
        thickness: 1.h,
        color: colors.border.withValues(alpha: 0.72),
      ),
    );
  }
}
