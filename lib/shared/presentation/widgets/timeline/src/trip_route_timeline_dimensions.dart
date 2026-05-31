part of '../trip_route_timeline.dart';

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
