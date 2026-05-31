import 'package:bawabat_al_saeq/features/home/presentation/widgets/empty/home_empty_icon_metrics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeEmptyIconFrame extends StatelessWidget {
  const HomeEmptyIconFrame({required this.builder, super.key});

  final Widget Function(BuildContext context, HomeEmptyIconMetrics metrics)
  builder;

  @override
  Widget build(BuildContext context) {
    final metrics = HomeEmptyIconMetrics(
      outerSize: 190.r,
      baseSize: 136.r,
      innerSize: 86.r,
    );

    return SizedBox.square(
      dimension: metrics.outerSize,
      child: builder(context, metrics),
    );
  }
}
