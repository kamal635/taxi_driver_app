import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/app/theme/app_theme_colors.dart';
import 'package:bawabat_al_saeq/app/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum TripRouteStopType {
  pickup,
  dropoff,
}

enum TripRouteTimelineDensity {
  regular,
  compact,
}

enum TripRouteTimelineTextLayout {
  stacked,
  inline,
}

@immutable
class TripRouteStopData {
  const TripRouteStopData({
    required this.label,
    required this.value,
    required this.type,
  });

  final String label;
  final String value;
  final TripRouteStopType type;
}

class TripRouteTimeline extends StatelessWidget {
  const TripRouteTimeline({
    required this.stops,
    this.density = TripRouteTimelineDensity.regular,
    this.textLayout = TripRouteTimelineTextLayout.stacked,
    this.maxValueLines = 2,
    super.key,
  });

  final List<TripRouteStopData> stops;
  final TripRouteTimelineDensity density;
  final TripRouteTimelineTextLayout textLayout;
  final int maxValueLines;

  @override
  Widget build(BuildContext context) {
    if (stops.isEmpty) {
      return const SizedBox.shrink();
    }

    final dimensions = _TripRouteTimelineDimensions.fromDensity(density);
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Stack(
      children: [
        if (stops.length > 1)
          Positioned(
            top: dimensions.connectorTop.r,
            bottom: dimensions.connectorBottom.r,
            left: isRtl ? null : dimensions.markerCenterOffset.r,
            right: isRtl ? dimensions.markerCenterOffset.r : null,
            child: _TripRouteConnector(
              width: dimensions.connectorWidth.r,
              dotted: dimensions.isConnectorDotted,
            ),
          ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(stops.length, (index) {
            final isLast = index == stops.length - 1;

            return Padding(
              padding: EdgeInsets.only(
                bottom: isLast ? 0 : dimensions.itemSpacing.h,
              ),
              child: _TripRouteStopTile(
                stop: stops[index],
                dimensions: dimensions,
                textLayout: textLayout,
                maxValueLines: maxValueLines,
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _TripRouteStopTile extends StatelessWidget {
  const _TripRouteStopTile({
    required this.stop,
    required this.dimensions,
    required this.textLayout,
    required this.maxValueLines,
  });

  final TripRouteStopData stop;
  final _TripRouteTimelineDimensions dimensions;
  final TripRouteTimelineTextLayout textLayout;
  final int maxValueLines;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: dimensions.markerTopPadding.h),
          child: _TripRouteMarker(
            type: stop.type,
            size: dimensions.markerSize.r,
            innerSize: dimensions.innerDotSize.r,
          ),
        ),
        AppSpacing.w12,
        Expanded(
          child: _TripRouteStopText(
            stop: stop,
            textLayout: textLayout,
            maxValueLines: maxValueLines,
            dimensions: dimensions,
          ),
        ),
      ],
    );
  }
}

class _TripRouteStopText extends StatelessWidget {
  const _TripRouteStopText({
    required this.stop,
    required this.textLayout,
    required this.maxValueLines,
    required this.dimensions,
  });

  final TripRouteStopData stop;
  final TripRouteTimelineTextLayout textLayout;
  final int maxValueLines;
  final _TripRouteTimelineDimensions dimensions;

  @override
  Widget build(BuildContext context) {
    return switch (textLayout) {
      TripRouteTimelineTextLayout.inline => _InlineTripRouteStopText(
        stop: stop,
        maxLines: maxValueLines,
        dimensions: dimensions,
      ),
      TripRouteTimelineTextLayout.stacked => _StackedTripRouteStopText(
        stop: stop,
        maxLines: maxValueLines,
        dimensions: dimensions,
      ),
    };
  }
}

class _InlineTripRouteStopText extends StatelessWidget {
  const _InlineTripRouteStopText({
    required this.stop,
    required this.maxLines,
    required this.dimensions,
  });

  final TripRouteStopData stop;
  final int maxLines;
  final _TripRouteTimelineDimensions dimensions;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: dimensions.inlineTextTopPadding.h),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '${stop.label}: ',
              style: AppTypography.subtitleSm.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: dimensions.compactFontSize.sp,
              ),
            ),
            TextSpan(
              text: stop.value,
              style: AppTypography.bodySm.copyWith(
                fontSize: dimensions.compactFontSize.sp,
              ),
            ),
          ],
        ),
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _StackedTripRouteStopText extends StatelessWidget {
  const _StackedTripRouteStopText({
    required this.stop,
    required this.maxLines,
    required this.dimensions,
  });

  final TripRouteStopData stop;
  final int maxLines;
  final _TripRouteTimelineDimensions dimensions;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          stop.label,
          style: AppTypography.subtitleSm.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: dimensions.labelValueSpacing.h),
        Text(
          stop.value,
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.bodyMd.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _TripRouteMarker extends StatelessWidget {
  const _TripRouteMarker({
    required this.type,
    required this.size,
    required this.innerSize,
  });

  final TripRouteStopType type;
  final double size;
  final double innerSize;

  @override
  Widget build(BuildContext context) {
    final palette = _TripRoutePalette.fromType(context, type);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: palette.backgroundColor,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Container(
        width: innerSize,
        height: innerSize,
        decoration: BoxDecoration(
          color: palette.dotColor,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class _TripRouteConnector extends StatelessWidget {
  const _TripRouteConnector({
    required this.width,
    required this.dotted,
  });

  final double width;
  final bool dotted;

  @override
  Widget build(BuildContext context) {
    final color = context.colors.iconMuted.withValues(alpha: 0.42);

    if (!dotted) {
      return Container(width: width, color: context.colors.border);
    }

    return CustomPaint(
      painter: _DottedVerticalLinePainter(color: color),
      child: SizedBox(width: width, height: double.infinity),
    );
  }
}

class _DottedVerticalLinePainter extends CustomPainter {
  const _DottedVerticalLinePainter({
    required this.color,
  });

  final Color color;

  static const double _dotDiameter = 2;
  static const double _gap = 3;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    const radius = _dotDiameter / 2;
    final centerX = size.width / 2;
    var currentY = radius;

    while (currentY <= size.height - radius) {
      canvas.drawCircle(Offset(centerX, currentY), radius, paint);
      currentY += _dotDiameter + _gap;
    }
  }

  @override
  bool shouldRepaint(covariant _DottedVerticalLinePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

class _TripRoutePalette {
  const _TripRoutePalette({
    required this.dotColor,
    required this.backgroundColor,
  });

  factory _TripRoutePalette.fromType(
    BuildContext context,
    TripRouteStopType type,
  ) {
    return switch (type) {
      TripRouteStopType.pickup => _TripRoutePalette(
        dotColor: context.colors.info,
        backgroundColor: context.colors.infoBg,
      ),
      TripRouteStopType.dropoff => _TripRoutePalette(
        dotColor: context.colors.error,
        backgroundColor: context.colors.errorBg,
      ),
    };
  }

  final Color dotColor;
  final Color backgroundColor;
}

class _TripRouteTimelineDimensions {
  const _TripRouteTimelineDimensions({
    required this.markerSize,
    required this.innerDotSize,
    required this.markerTopPadding,
    required this.markerCenterOffset,
    required this.connectorTop,
    required this.connectorBottom,
    required this.connectorWidth,
    required this.itemSpacing,
    required this.labelValueSpacing,
    required this.inlineTextTopPadding,
    required this.compactFontSize,
    required this.isConnectorDotted,
  });

  factory _TripRouteTimelineDimensions.fromDensity(
    TripRouteTimelineDensity density,
  ) {
    return switch (density) {
      TripRouteTimelineDensity.regular => const _TripRouteTimelineDimensions(
        markerSize: 14,
        innerDotSize: 6,
        markerTopPadding: 2,
        markerCenterOffset: 6,
        connectorTop: 10,
        connectorBottom: 10,
        connectorWidth: 2,
        itemSpacing: 24,
        labelValueSpacing: 4,
        inlineTextTopPadding: 0,
        compactFontSize: 10,
        isConnectorDotted: false,
      ),
      TripRouteTimelineDensity.compact => const _TripRouteTimelineDimensions(
        markerSize: 12,
        innerDotSize: 6,
        markerTopPadding: 2,
        markerCenterOffset: 5,
        connectorTop: 10,
        connectorBottom: 10,
        connectorWidth: 2,
        itemSpacing: 8,
        labelValueSpacing: 2,
        inlineTextTopPadding: 0,
        compactFontSize: 10,
        isConnectorDotted: true,
      ),
    };
  }

  final double markerSize;
  final double innerDotSize;
  final double markerTopPadding;
  final double markerCenterOffset;
  final double connectorTop;
  final double connectorBottom;
  final double connectorWidth;
  final double itemSpacing;
  final double labelValueSpacing;
  final double inlineTextTopPadding;
  final double compactFontSize;
  final bool isConnectorDotted;
}
