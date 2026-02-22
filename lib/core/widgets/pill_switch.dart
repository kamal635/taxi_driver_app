import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/app/theme/app_typography.dart';

class PillSwitch extends StatefulWidget {
  const PillSwitch({
    required this.value,
    required this.onChanged,
    required this.onLabel,
    required this.offLabel,
    super.key,
    this.duration = const Duration(milliseconds: 900),
    this.height,
    this.uppercase = true,
    this.maxWidth,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  final String onLabel;
  final String offLabel;

  final Duration duration;
  final double? height;
  final bool uppercase;

  /// Optional maximum width for the whole pill.
  /// If null, the pill will use the measured "largest label" width.
  final double? maxWidth;

  @override
  State<PillSwitch> createState() => _PillSwitchState();
}

class _PillSwitchState extends State<PillSwitch> {
  late bool _fromValue;
  late bool _toValue;

  bool _animating = false;
  int _animSeed = 0;

  // Cached text metrics to avoid running TextPainter on every rebuild.
  double _maxLabelW = 0;

  String? _cacheOnText;
  String? _cacheOffText;
  int? _cacheStyleHash;
  double? _cacheTextScaleKey;
  TextDirection? _cacheDirection;

  @override
  void initState() {
    super.initState();
    _fromValue = widget.value;
    _toValue = widget.value;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateLabelMetricsIfNeeded();
  }

  @override
  void didUpdateWidget(covariant PillSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If labels or uppercase flag changed, recalculate cached metrics.
    if (oldWidget.onLabel != widget.onLabel ||
        oldWidget.offLabel != widget.offLabel ||
        oldWidget.uppercase != widget.uppercase) {
      _updateLabelMetricsIfNeeded(force: true);
    } else {
      // Dependencies (text scale / direction) can still change, keep it safe & cheap.
      _updateLabelMetricsIfNeeded();
    }

    // When the external value changes, start the wipe animation.
    if (oldWidget.value != widget.value) {
      setState(() {
        _fromValue = oldWidget.value;
        _toValue = widget.value;
        _animating = true;
        _animSeed++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = widget.height ?? 30.h;
    final radius = BorderRadius.circular(999.r);

    final paddingX = 10.w;
    final gap = 12.w;
    final ringSize = 18.r;
    final safety = 6.w;

    final contentPadding = EdgeInsets.symmetric(horizontal: paddingX);

    // Use cached max label width (precomputed in lifecycle hooks).
    final desiredWidth = _maxLabelW + (paddingX * 2) + gap + ringSize + safety;

    Color bgFor({required bool v}) =>
        v ? AppColors.successBg : AppColors.errorBg;
    Color accentFor({required bool v}) =>
        v ? AppColors.success : AppColors.error;

    Widget contentRow({required bool v}) {
      final accent = accentFor(v: v);
      const ringBorderWidth = 2.2;
      final label = _shownLabelFor(v);

      final isRtl = Directionality.of(context) == TextDirection.rtl;

      TextStyle labelStyle({required bool v}) {
        final base = AppTypography.subtitleSm.copyWith(
          fontWeight: FontWeight.w900,
          letterSpacing: 0.8,
          color: accent,
        );

        // Arabic (RTL): shrink only when OFF
        if (isRtl && !v) {
          return base.copyWith(fontSize: 10.sp);
        }

        // English (LTR) OR ON state: keep default size
        return base;
      }

      return Row(
        children: [
          // Expanded keeps the ring pinned to the far end,
          // regardless of how short the label is.
          Expanded(
            child: Tooltip(
              // Shows the full label without changing the pill size.
              message: label,
              child: Text(
                label,
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.ellipsis, // Prevents overflow.
                style: labelStyle(v: v),
              ),
            ),
          ),
          SizedBox(width: gap),
          Container(
            width: ringSize,
            height: ringSize,
            decoration: BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: accent,
                width: ringBorderWidth,
              ),
            ),
          ),
        ],
      );
    }

    final baseBg = _animating ? bgFor(v: _fromValue) : bgFor(v: widget.value);
    final overlayBg = bgFor(v: _toValue);

    return LayoutBuilder(
      builder: (context, constraints) {
        var fixedWidth = desiredWidth;

        if (widget.maxWidth != null) {
          fixedWidth = math.min(fixedWidth, widget.maxWidth!);
        }
        if (constraints.hasBoundedWidth) {
          fixedWidth = math.min(fixedWidth, constraints.maxWidth);
        }

        final pillBody = InkWell(
          borderRadius: radius,
          onTap: _animating ? null : () => widget.onChanged(!widget.value),
          child: Container(
            decoration: BoxDecoration(
              color: baseBg,
              borderRadius: radius,
              border: Border.all(color: AppColors.white, width: 2.r),
              boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                  color: Colors.black.withValues(alpha: 0.10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: radius,
              child: SizedBox(
                height: h,
                child: Stack(
                  children: [
                    // Base (old) content layer.
                    Padding(
                      padding: contentPadding,
                      child: Align(
                        // Direction-aware alignment (LTR/RTL).
                        alignment: AlignmentDirectional.centerStart,
                        child: contentRow(
                          v: _animating ? _fromValue : widget.value,
                        ),
                      ),
                    ),

                    // Animated fill + partially revealed new content.
                    if (_animating)
                      Positioned.fill(
                        child: TweenAnimationBuilder<double>(
                          key: ValueKey(_animSeed),
                          tween: Tween<double>(begin: 0, end: 1),
                          duration: widget.duration,
                          curve: Curves.easeOutCubic,
                          onEnd: () {
                            if (!mounted) return;
                            setState(() {
                              _animating = false;
                              _fromValue = _toValue;
                            });
                          },
                          builder: (context, t, _) {
                            final dir = Directionality.of(context);
                            final clipper = _FillClipperDirectional(
                              t,
                              textDirection: dir,
                            );

                            return Stack(
                              children: [
                                // Fill background (reveals from START to END).
                                ClipRect(
                                  clipper: clipper,
                                  child: SizedBox.expand(
                                    child: ColoredBox(color: overlayBg),
                                  ),
                                ),

                                // New content revealed using the same clip.
                                ClipRect(
                                  clipper: clipper,
                                  child: Padding(
                                    padding: contentPadding,
                                    child: Align(
                                      // Direction-aware alignment (LTR/RTL).
                                      alignment:
                                          AlignmentDirectional.centerStart,
                                      child: contentRow(v: _toValue),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );

        // Lock width to avoid top bar title shifting.
        return SizedBox(width: fixedWidth, child: pillBody);
      },
    );
  }

  String _shownLabelFor(bool v) {
    final raw = v ? widget.onLabel : widget.offLabel;
    return widget.uppercase ? raw.toUpperCase() : raw;
  }

  void _updateLabelMetricsIfNeeded({bool force = false}) {
    final textStyle = AppTypography.subtitleSm.copyWith(
      fontWeight: FontWeight.w900,
      letterSpacing: 0.8,
    );

    final textScaler = MediaQuery.textScalerOf(context);
    final direction = Directionality.of(context);

    final onText = _shownLabelFor(true);
    final offText = _shownLabelFor(false);

    // Stable key for TextScaler changes.
    final textScaleKey = textScaler.scale(1);
    final styleHash = textStyle.hashCode;

    if (!force &&
        _cacheOnText == onText &&
        _cacheOffText == offText &&
        _cacheStyleHash == styleHash &&
        _cacheTextScaleKey == textScaleKey &&
        _cacheDirection == direction) {
      return;
    }

    final onW = _measureTextWidth(onText, textStyle, direction, textScaler);
    final offW = _measureTextWidth(offText, textStyle, direction, textScaler);

    _maxLabelW = math.max(onW, offW);

    _cacheOnText = onText;
    _cacheOffText = offText;
    _cacheStyleHash = styleHash;
    _cacheTextScaleKey = textScaleKey;
    _cacheDirection = direction;
  }

  double _measureTextWidth(
    String text,
    TextStyle style,
    TextDirection direction,
    TextScaler textScaler,
  ) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: direction,
      textScaler: textScaler,
    )..layout();
    return painter.width;
  }
}

/// Clips a rectangle from START to END based on [t] (0..1).
/// LTR: left -> right
/// RTL: right -> left
class _FillClipperDirectional extends CustomClipper<Rect> {
  _FillClipperDirectional(this.t, {required this.textDirection});

  final double t;
  final TextDirection textDirection;

  @override
  Rect getClip(Size size) {
    final w = size.width * t.clamp(0.0, 1.0);

    if (textDirection == TextDirection.rtl) {
      // Reveal from right to left.
      return Rect.fromLTWH(size.width - w, 0, w, size.height);
    }

    // Reveal from left to right.
    return Rect.fromLTWH(0, 0, w, size.height);
  }

  @override
  bool shouldReclip(covariant _FillClipperDirectional oldClipper) =>
      oldClipper.t != t || oldClipper.textDirection != textDirection;
}
