import 'package:flutter/material.dart';

/// Centers the page content and limits its width on larger screens.
class CenteredPage extends StatelessWidget {
  const CenteredPage({
    required this.child,
    super.key,
  });

  static const double _desktopMaxWidth = 560;
  static const double _tabletMaxWidth = 520;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    final maxWidth = switch (screenWidth) {
      >= 1024 => _desktopMaxWidth,
      >= 600 => _tabletMaxWidth,
      _ => double.infinity,
    };

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
