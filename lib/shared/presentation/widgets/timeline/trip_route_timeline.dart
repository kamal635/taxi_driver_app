import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/app/theme/app_theme_colors.dart';
import 'package:bawabat_al_saeq/app/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

part 'src/trip_route_connector.dart';
part 'src/trip_route_marker.dart';
part 'src/trip_route_stop_data.dart';
part 'src/trip_route_stop_tile.dart';
part 'src/trip_route_timeline_dimensions.dart';

enum TripRouteTimelineDensity {
  regular,
  compact,
}

enum TripRouteTimelineTextLayout {
  stacked,
  inline,
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
