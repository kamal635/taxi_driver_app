import 'dart:ui';

Size pickDesignSize() {
  final dispatcher = PlatformDispatcher.instance;

  // Prefer implicitView when available (more stable in tests),
  // otherwise fall back to the first view if any.
  final view =
      dispatcher.implicitView ??
      (dispatcher.views.isNotEmpty ? dispatcher.views.first : null);

  // In some test environments there may be no views yet.
  if (view == null) {
    return const Size(360, 800); // Safe default (phone)
  }

  final dpr = view.devicePixelRatio;
  if (dpr == 0) {
    return const Size(360, 800);
  }

  final logicalSize = view.physicalSize / dpr;
  final shortestSide = logicalSize.shortestSide;

  // If the test view has no size, use a safe default.
  if (shortestSide <= 0 || shortestSide.isNaN) {
    return const Size(360, 800);
  }

  if (shortestSide >= 600) {
    return const Size(768, 1024); // Tablet design
  }
  return const Size(360, 800); // Phone design
}
