import 'package:bawabat_al_saeq/app/theme/app_colors.dart';
import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/app/theme/app_typography.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Pickup and dropoff section used by both offer card variants.
class OfferRouteSection extends StatelessWidget {
  const OfferRouteSection({
    required this.pickup,
    required this.dropoff,
    super.key,
  });

  final String pickup;
  final String dropoff;

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final l10n = context.l10n;

    final stops = [
      _RouteStopData(
        label: l10n.homePickupPrefix,
        title: pickup,
        color: AppColors.info,
      ),
      _RouteStopData(
        label: l10n.homeDropoffPrefix,
        title: dropoff,
        color: AppColors.error,
      ),
    ];

    return Stack(
      children: [
        Positioned(
          left: isRtl ? null : 5.r,
          right: isRtl ? 5.r : null,
          top: 10.r,
          bottom: 10.r,
          child: Container(
            width: 3.r,
            color: AppColors.border,
          ),
        ),
        Column(
          children: List.generate(stops.length, (index) {
            final stop = stops[index];
            final isLast = index == stops.length - 1;

            return Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 24.r),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: 14.r,
                      height: 14.r,
                      decoration: BoxDecoration(
                        color: stop.color.withValues(alpha: 0.18),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Container(
                          width: 6.r,
                          height: 6.r,
                          decoration: BoxDecoration(
                            color: stop.color.withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                  AppSpacing.w16,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stop.label,
                          style: AppTypography.subtitleSm.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        AppSpacing.h4,
                        Text(
                          stop.title,
                          style: AppTypography.bodyMd.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _RouteStopData {
  const _RouteStopData({
    required this.label,
    required this.title,
    required this.color,
  });

  final String label;
  final String title;
  final Color color;
}
