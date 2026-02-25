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
    this.duration = const Duration(milliseconds: 700),
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

class _PillSwitchState extends State<PillSwitch>
    with SingleTickerProviderStateMixin {
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

  // -----------------------------
  // Ring pulse animation
  // -----------------------------
  late final AnimationController _ringCtrl;
  late final Animation<double> _ringScale;
  int? _ringBumpedForSeed; // ensures "once per toggle"

  @override
  void initState() {
    super.initState();
    _fromValue = widget.value;
    _toValue = widget.value;

    _ringCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    // Pulse: 1.0 -> 1.18 -> 0.95 -> 1.0
    _ringScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1,
          end: 1.18,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 45,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.18,
          end: 0.95,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.95,
          end: 1,
        ).chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 25,
      ),
    ]).animate(_ringCtrl);
  }

  @override
  void dispose() {
    _ringCtrl.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateLabelMetricsIfNeeded();
  }

  @override
  void didUpdateWidget(covariant PillSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.onLabel != widget.onLabel ||
        oldWidget.offLabel != widget.offLabel ||
        oldWidget.uppercase != widget.uppercase) {
      _updateLabelMetricsIfNeeded(force: true);
    } else {
      _updateLabelMetricsIfNeeded();
    }

    if (oldWidget.value != widget.value) {
      setState(() {
        _fromValue = oldWidget.value;
        _toValue = widget.value;
        _animating = true;
        _animSeed++;
        _ringBumpedForSeed = null; // reset bump for the new animation
      });
    }
  }

  void _maybeBumpRing({
    required double t,
    required double threshold,
  }) {
    if (_ringBumpedForSeed == _animSeed) return;
    if (t < threshold) return;

    _ringBumpedForSeed = _animSeed;

    // Avoid doing work inside the build of TweenAnimationBuilder.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await _ringCtrl.forward(from: 0);
    });
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

    final desiredWidth = _maxLabelW + (paddingX * 2) + gap + ringSize + safety;

    Color bgFor({required bool v}) =>
        v ? AppColors.successBg : AppColors.errorBg;
    Color accentFor({required bool v}) =>
        v ? AppColors.success : AppColors.error;

    Widget ringWidget({required Color accent, required bool bumpable}) {
      const ringBorderWidth = 2.2;

      final ring = Container(
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
      );

      if (!bumpable) return ring;
      return ScaleTransition(scale: _ringScale, child: ring);
    }

    Widget contentRow({required bool v, required bool bumpableRing}) {
      final accent = accentFor(v: v);
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
        return base;
      }

      return Row(
        children: [
          Expanded(
            child: Tooltip(
              message: label,
              child: Text(
                label,
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                style: labelStyle(v: v),
              ),
            ),
          ),
          SizedBox(width: gap),
          ringWidget(accent: accent, bumpable: bumpableRing),
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

        // When the wipe reaches the ring area (near the end padding),
        // bump the ring.
        // Works for both LTR & RTL because reveal "reaches the far end" at the
        //same t.
        final bumpThreshold = (1.0 - (paddingX / fixedWidth)).clamp(0.0, 1.0);

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
                        alignment: AlignmentDirectional.centerStart,
                        child: contentRow(
                          v: _animating ? _fromValue : widget.value,
                          bumpableRing: false,
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
                            _maybeBumpRing(t: t, threshold: bumpThreshold);

                            final dir = Directionality.of(context);
                            final clipper = _FillClipperDirectional(
                              t,
                              textDirection: dir,
                            );

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
                                      alignment:
                                          AlignmentDirectional.centerStart,
                                      child: contentRow(
                                        v: _toValue,
                                        bumpableRing: true,
                                      ),
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
      return Rect.fromLTWH(size.width - w, 0, w, size.height);
    }
    return Rect.fromLTWH(0, 0, w, size.height);
  }

  @override
  bool shouldReclip(covariant _FillClipperDirectional oldClipper) =>
      oldClipper.t != t || oldClipper.textDirection != textDirection;
}
