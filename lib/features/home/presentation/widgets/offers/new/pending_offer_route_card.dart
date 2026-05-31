import 'package:bawabat_al_saeq/app/theme/app_theme_colors.dart';
import 'package:bawabat_al_saeq/app/theme/app_typography.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PendingOfferRouteCard extends StatelessWidget {
  const PendingOfferRouteCard({
    required this.pickup,
    required this.dropoff,
    super.key,
  });

  final String pickup;
  final String? dropoff;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final resolvedPickup = pickup.trim().isEmpty ? l10n.unknown : pickup.trim();
    final resolvedDropoff = _resolveNullableLocation(
      dropoff,
      fallback: l10n.unknown,
    );

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: colors.surfaceMuted,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              _RouteDot(color: colors.info, backgroundColor: colors.infoBg),
              Container(
                width: 2.w,
                height: 34.h,
                margin: EdgeInsets.symmetric(vertical: 4.h),
                decoration: BoxDecoration(
                  color: colors.border,
                  borderRadius: BorderRadius.circular(999.r),
                ),
              ),
              _RouteDot(color: colors.error, backgroundColor: colors.errorBg),
            ],
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              children: [
                _RouteLine(
                  label: l10n.homePickupPrefix,
                  value: resolvedPickup,
                ),
                SizedBox(height: 14.h),
                _RouteLine(
                  label: l10n.homeDropoffPrefix,
                  value: resolvedDropoff,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _resolveNullableLocation(String? value, {required String fallback}) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return fallback;
    }

    return trimmed;
  }
}

class _RouteDot extends StatelessWidget {
  const _RouteDot({
    required this.color,
    required this.backgroundColor,
  });

  final Color color;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24.r,
      height: 24.r,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Container(
        width: 10.r,
        height: 10.r,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class _RouteLine extends StatelessWidget {
  const _RouteLine({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label:',
          style: AppTypography.labelMd.copyWith(
            color: colors.textSecondary,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(width: 6.w),
        Expanded(
          child: Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.bodyMd.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}
