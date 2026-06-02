import 'package:bawabat_al_saeq/app/theme/app_theme_colors.dart';
import 'package:bawabat_al_saeq/app/theme/app_typography.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Shared pickup/dropoff block used by all offer states.
///
/// The route is rendered as a flat timeline inside the main offer card rather
/// than as a separate nested card. This keeps the layout visually calmer while
/// preserving the pickup/dropoff dots.
class OfferRouteCard extends StatelessWidget {
  const OfferRouteCard({
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
    final resolvedPickup = _resolveLocation(pickup, fallback: l10n.unknown);
    final resolvedDropoff = _resolveLocation(dropoff, fallback: l10n.unknown);

    return Stack(
      children: [
        PositionedDirectional(
          start: 11.r,
          top: 29.h,
          bottom: 29.h,
          child: Container(
            width: 2.w,
            decoration: BoxDecoration(
              color: colors.border,
              borderRadius: BorderRadius.circular(999.r),
            ),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _OfferRouteStop(
              label: l10n.homePickupPrefix,
              value: resolvedPickup,
              dotColor: colors.info,
              dotBackgroundColor: colors.infoBg,
            ),
            SizedBox(height: 16.h),
            _OfferRouteStop(
              label: l10n.homeDropoffPrefix,
              value: resolvedDropoff,
              dotColor: colors.error,
              dotBackgroundColor: colors.errorBg,
            ),
          ],
        ),
      ],
    );
  }

  String _resolveLocation(String? value, {required String fallback}) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return fallback;
    }

    return trimmed;
  }
}

class _OfferRouteStop extends StatelessWidget {
  const _OfferRouteStop({
    required this.label,
    required this.value,
    required this.dotColor,
    required this.dotBackgroundColor,
  });

  final String label;
  final String value;
  final Color dotColor;
  final Color dotBackgroundColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 2.h),
          child: _OfferRouteDot(
            color: dotColor,
            backgroundColor: dotBackgroundColor,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 1.h),
            child: _OfferRouteLine(
              label: label,
              value: value,
            ),
          ),
        ),
      ],
    );
  }
}

class _OfferRouteDot extends StatelessWidget {
  const _OfferRouteDot({
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

class _OfferRouteLine extends StatelessWidget {
  const _OfferRouteLine({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$label: ',
            style: AppTypography.labelMd.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.w800,
            ),
          ),
          TextSpan(
            text: value,
            style: AppTypography.bodyMd.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.start,
    );
  }
}
