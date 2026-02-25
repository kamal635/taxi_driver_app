import 'dart:math' as math;

import 'package:flutter/widgets.dart';

Size pickDesignSizeFromConstraints(BoxConstraints c) {
  final w = c.maxWidth.isFinite ? c.maxWidth : 0.0;
  final h = c.maxHeight.isFinite ? c.maxHeight : 0.0;

  final shortest = math.min(w, h);

  // Safe default (tests/edge cases)
  if (shortest <= 0 || shortest.isNaN) {
    return const Size(360, 800);
  }

  // Desktop / Large screens
  if (w >= 1024) {
    return const Size(1440, 900);
  }

  // Tablet
  if (shortest >= 600) {
    return const Size(768, 1024);
  }

  // Phone
  return const Size(360, 800);
}
