part of '../trip_route_timeline.dart';

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
