import 'package:flutter/material.dart';

class CenteredPage extends StatelessWidget {
  const CenteredPage({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    final max = width >= 1024
        ? 560.0 // desktop
        : width >= 600
        ? 520.0 // tablet
        : double.infinity;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: max),
        child: child,
      ),
    );
  }
}
