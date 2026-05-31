import 'package:flutter/material.dart';

class HomeEmptyStateCircleLayer extends StatelessWidget {
  const HomeEmptyStateCircleLayer({
    required this.size,
    required this.color,
    required this.borderColor,
    super.key,
  });

  final double size;
  final Color color;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(
          color: borderColor,
          width: 1.2,
        ),
      ),
    );
  }
}
