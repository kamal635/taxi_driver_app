part of '../trip_route_timeline.dart';

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
