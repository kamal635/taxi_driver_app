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

  // ---- Cached text metrics (to avoid TextPainter layout on every rebuild)
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

    // If labels/uppercase changed => update cached metrics.
    if (oldWidget.onLabel != widget.onLabel ||
        oldWidget.offLabel != widget.offLabel ||
        oldWidget.uppercase != widget.uppercase) {
      _updateLabelMetricsIfNeeded(force: true);
    } else {
      // Still might change due to inherited updates; keep it safe & cheap.
      _updateLabelMetricsIfNeeded();
    }

    // Value change => start animation (same logic as your code).
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

    final baseTextStyle = AppTypography.subtitleSm.copyWith(
      fontWeight: FontWeight.w900,
      letterSpacing: 0.8,
    );

    final contentPadding = EdgeInsets.symmetric(horizontal: paddingX);

    // Use cached max label width (computed in didChangeDependencies / didUpdateWidget)
    final desiredWidth = _maxLabelW + (paddingX * 2) + gap + ringSize + safety;

    Color bgFor({required bool v}) =>
        v ? AppColors.successBg : AppColors.errorBg;
    Color accentFor({required bool v}) =>
        v ? AppColors.success : AppColors.error;

    Widget contentRow({required bool v}) {
      final accent = accentFor(v: v);
      const ringBorderWidth = 2.2;

      return Row(
        children: [
          Flexible(
            child: Text(
              _shownLabelFor(v),
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
              style: baseTextStyle.copyWith(color: accent),
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
                    // Base (old) content
                    Padding(
                      padding: contentPadding,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: contentRow(
                          v: _animating ? _fromValue : widget.value,
                        ),
                      ),
                    ),

                    // Animated fill + revealed next content (LEFT -> RIGHT)
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
                            final clipper = _FillClipperLTR(t);

                            return Stack(
                              children: [
                                ClipRect(
                                  clipper: clipper,
                                  child: SizedBox.expand(
                                    child: ColoredBox(color: overlayBg),
                                  ),
                                ),
                                ClipRect(
                                  clipper: clipper,
                                  child: Padding(
                                    padding: contentPadding,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
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

        // Lock width => no title shifting
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

    // Stable key for text scaling (works well with TextScaler)
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

/// Clips a rectangle from LEFT to RIGHT based on [t] (0..1).
class _FillClipperLTR extends CustomClipper<Rect> {
  _FillClipperLTR(this.t);

  final double t;

  @override
  Rect getClip(Size size) {
    final w = size.width * t.clamp(0.0, 1.0);
    return Rect.fromLTWH(0, 0, w, size.height);
  }

  @override
  bool shouldReclip(covariant _FillClipperLTR oldClipper) => oldClipper.t != t;
}
