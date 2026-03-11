import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/app/theme/app_typography.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';

class RoutePickupAndDropoff extends StatelessWidget {
  const RoutePickupAndDropoff({
    required this.dropoff,
    required this.pickup,
    super.key,
  });

  final String pickup;
  final String dropoff;

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    final l10n = context.l10n;
    final stops = [
      RouteStopData(
        type: l10n.homePickupPrefix,
        title: pickup,
        color: AppColors.info,
      ),
      RouteStopData(
        type: l10n.homeDropoffPrefix,
        title: dropoff,
        color: AppColors.error,
      ),
    ];

    return Stack(
      children: [
        // Vertical line behind all items
        if (isRTL)
          Positioned(
            right: 4.5.r,
            top: 10.r,
            bottom: 10.r,
            child: Container(
              width: 3.r,
              color: AppColors.border,
            ),
          )
        else
          Positioned(
            left: 4.5.r,
            top: 10.r,
            bottom: 10.r,
            child: Container(
              width: 3.r,
              color: AppColors.border,
            ),
          ),
        Column(
          children: List.generate(2, (index) {
            final stop = stops[index];
            final isLast = index == stops.length - 1;

            return Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 24.r),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dot area
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: 12.r,
                      height: 12.r,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: stop.color.withValues(alpha: 0.2),
                          width: 16.r,
                        ),
                        color: stop.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),

                  AppSpacing.w16,

                  // // Text area
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stop.type,
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

class RouteStopData {
  const RouteStopData({
    required this.type,
    required this.title,
    required this.color,
  });

  final String type;
  final String title;
  final Color color;
}
