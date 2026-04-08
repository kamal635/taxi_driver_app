import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/app/theme/app_typography.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';

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
    final l10n = context.l10n;

    final stops = [
      _RouteStopData(
        label: l10n.homePickupPrefix,
        title: pickup,
        type: _RouteStopType.pickup,
      ),
      _RouteStopData(
        label: l10n.homeDropoffPrefix,
        title: dropoff,
        type: _RouteStopType.dropoff,
      ),
    ];

    if (stops.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        stops.length,
        (index) {
          final stop = stops[index];
          final isLast = index == stops.length - 1;

          return Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 1.h),
            child: _OfferRouteTimelineTile(
              stop: stop,
              isLast: isLast,
            ),
          );
        },
      ),
    );
  }
}

class _OfferRouteTimelineTile extends StatelessWidget {
  const _OfferRouteTimelineTile({
    required this.stop,
    required this.isLast,
  });

  final _RouteStopData stop;
  final bool isLast;

  static const double _minConnectorHeight = 66;
  static const double _connectorTopOffset = 14;
  static const double _minTileHeight =
      _connectorTopOffset + _minConnectorHeight;

  @override
  Widget build(BuildContext context) {
    final palette = _RouteTimelinePalette.fromType(stop.type);

    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: _minTileHeight,
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 20.w,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  if (!isLast)
                    const Positioned.fill(
                      top: _connectorTopOffset,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: _DottedVerticalConnector(),
                      ),
                    ),
                  Padding(
                    padding: EdgeInsets.only(top: 2.h),
                    child: _RouteTimelineMarker(palette: palette),
                  ),
                ],
              ),
            ),
            AppSpacing.w4,
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
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
                      softWrap: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RouteTimelineMarker extends StatelessWidget {
  const _RouteTimelineMarker({
    required this.palette,
  });

  final _RouteTimelinePalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18.r,
      height: 18.r,
      decoration: BoxDecoration(
        color: palette.backgroundColor,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Container(
        width: 9.r,
        height: 9.r,
        decoration: BoxDecoration(
          color: palette.dotColor,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class _DottedVerticalConnector extends StatelessWidget {
  const _DottedVerticalConnector();

  static const double minHeight = 12;
  static const double _dotSize = 2;
  static const double _gap = 1;
  static const int _minDots = 3;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final rawHeight = constraints.maxHeight;

        if (!rawHeight.isFinite || rawHeight <= 0) {
          return const SizedBox.shrink();
        }

        final height = rawHeight < minHeight ? minHeight : rawHeight;

        final dotCount = ((height + _gap) / (_dotSize + _gap)).floor().clamp(
          _minDots,
          100,
        );

        return SizedBox(
          width: _dotSize,
          height: height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              dotCount,
              (_) => Container(
                width: _dotSize,
                height: _dotSize,
                decoration: BoxDecoration(
                  color: AppColors.iconMuted.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

enum _RouteStopType {
  pickup,
  dropoff,
}

class _RouteStopData {
  const _RouteStopData({
    required this.label,
    required this.title,
    required this.type,
  });

  final String label;
  final String title;
  final _RouteStopType type;
}

class _RouteTimelinePalette {
  const _RouteTimelinePalette({
    required this.dotColor,
    required this.backgroundColor,
  });

  factory _RouteTimelinePalette.fromType(_RouteStopType type) {
    switch (type) {
      case _RouteStopType.pickup:
        return _RouteTimelinePalette(
          dotColor: AppColors.info,
          backgroundColor: AppColors.info.withValues(alpha: 0.1),
        );
      case _RouteStopType.dropoff:
        return _RouteTimelinePalette(
          dotColor: AppColors.error,
          backgroundColor: AppColors.error.withValues(alpha: 0.1),
        );
    }
  }

  final Color dotColor;
  final Color backgroundColor;
}
