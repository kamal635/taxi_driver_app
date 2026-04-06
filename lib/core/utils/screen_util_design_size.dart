import 'dart:math' as math;

import 'package:flutter/widgets.dart';

const Size _phoneDesignSize = Size(360, 800);
const Size _tabletDesignSize = Size(768, 1024);
const Size _desktopDesignSize = Size(1440, 900);

/// Picks a ScreenUtil design size based on the available layout constraints.
Size pickDesignSizeFromConstraints(BoxConstraints constraints) {
  final width = constraints.maxWidth.isFinite ? constraints.maxWidth : 0.0;
  final height = constraints.maxHeight.isFinite ? constraints.maxHeight : 0.0;
  final shortestSide = math.min(width, height);

  if (shortestSide <= 0 || shortestSide.isNaN) {
    return _phoneDesignSize;
  }

  if (width >= 1024) {
    return _desktopDesignSize;
  }

  if (shortestSide >= 600) {
    return _tabletDesignSize;
  }

  return _phoneDesignSize;
}
