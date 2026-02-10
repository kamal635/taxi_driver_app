import 'dart:ui';

Size pickDesignSize() {
  final view = PlatformDispatcher.instance.views.first;
  final logicalSize = view.physicalSize / view.devicePixelRatio;
  final shortestSide = logicalSize.shortestSide;

  // 600dp is a common breakpoint to distinguish phone vs tablet.
  if (shortestSide >= 600) {
    return const Size(768, 1024); // Tablet design size
  }
  return const Size(360, 800); // Phone design size
}
