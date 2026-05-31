import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeEmptyIconCore extends StatelessWidget {
  const HomeEmptyIconCore({
    required this.icon,
    required this.iconColor,
    required this.surfaceColor,
    required this.shadowColor,
    required this.size,
    super.key,
  });

  final IconData icon;
  final Color iconColor;
  final Color surfaceColor;
  final Color shadowColor;
  final double size;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: surfaceColor,
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 24.r,
            offset: Offset(0, 10.h),
          ),
        ],
      ),
      child: SizedBox.square(
        dimension: size,
        child: Icon(
          icon,
          size: 38.r,
          color: iconColor,
        ),
      ),
    );
  }
}
