part of '../trip_route_timeline.dart';

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
