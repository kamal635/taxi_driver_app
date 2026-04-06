import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/app/theme/app_typography.dart';

/// Animated on/off pill used for the driver availability toggle.
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
  final ValueChanged<bool>? onChanged;
  final String onLabel;
  final String offLabel;
  final Duration duration;
  final double? height;
  final bool uppercase;

  /// Optional maximum width for the whole pill.
  final double? maxWidth;

  @override
  State<PillSwitch> createState() => _PillSwitchState();
}

class _PillSwitchState extends State<PillSwitch>
    with SingleTickerProviderStateMixin {
  late bool _fromValue;
  late bool _toValue;

  bool _isAnimating = false;
  int _animationSeed = 0;

  double _maxLabelWidth = 0;

  String? _cachedOnText;
  String? _cachedOffText;
  int? _cachedStyleHash;
  double? _cachedTextScaleKey;
  TextDirection? _cachedDirection;

  late final AnimationController _ringController;
  late final Animation<double> _ringScale;
  int? _lastRingBumpSeed;

  @override
  void initState() {
    super.initState();
    _fromValue = widget.value;
    _toValue = widget.value;

    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    _ringScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1, end: 1.18).chain(
          CurveTween(curve: Curves.easeOut),
        ),
        weight: 45,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.18, end: 0.95).chain(
          CurveTween(curve: Curves.easeIn),
        ),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.95, end: 1).chain(
          CurveTween(curve: Curves.easeOutBack),
        ),
        weight: 25,
      ),
    ]).animate(_ringController);
  }

  @override
  void dispose() {
    _ringController.dispose();
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

    final labelsChanged =
        oldWidget.onLabel != widget.onLabel ||
        oldWidget.offLabel != widget.offLabel ||
        oldWidget.uppercase != widget.uppercase;

    _updateLabelMetricsIfNeeded(force: labelsChanged);

    if (oldWidget.value != widget.value) {
      setState(() {
        _fromValue = oldWidget.value;
        _toValue = widget.value;
        _isAnimating = true;
        _animationSeed++;
        _lastRingBumpSeed = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = widget.height ?? 30.h;
    final radius = BorderRadius.circular(999.r);

    final horizontalPadding = 10.w;
    final gap = 12.w;
    final ringSize = 18.r;
    final safety = 6.w;

    final contentPadding = EdgeInsets.symmetric(horizontal: horizontalPadding);

    final desiredWidth =
        _maxLabelWidth + (horizontalPadding * 2) + gap + ringSize + safety;

    Color backgroundFor({required bool value}) {
      return value ? AppColors.successBg : AppColors.errorBg;
    }

    Color accentFor({required bool value}) {
      return value ? AppColors.success : AppColors.error;
    }

    Widget buildRing({
      required Color accent,
      required bool animated,
    }) {
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

      if (!animated) {
        return ring;
      }

      return ScaleTransition(
        scale: _ringScale,
        child: ring,
      );
    }

    Widget buildContentRow({
      required bool value,
      required bool animatedRing,
    }) {
      final accent = accentFor(value: value);
      final label = _shownLabelFor(value);
      final isRtl = Directionality.of(context) == TextDirection.rtl;

      TextStyle labelStyle() {
        final baseStyle = AppTypography.subtitleSm.copyWith(
          fontWeight: FontWeight.w900,
          letterSpacing: 0.8,
          color: accent,
        );

        if (isRtl && !value) {
          return baseStyle.copyWith(fontSize: 10.sp);
        }

        return baseStyle;
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
                style: labelStyle(),
              ),
            ),
          ),
          SizedBox(width: gap),
          buildRing(
            accent: accent,
            animated: animatedRing,
          ),
        ],
      );
    }

    final baseBackground = _isAnimating
        ? backgroundFor(value: _fromValue)
        : backgroundFor(value: widget.value);
    final overlayBackground = backgroundFor(value: _toValue);

    return LayoutBuilder(
      builder: (context, constraints) {
        var fixedWidth = desiredWidth;

        if (widget.maxWidth != null) {
          fixedWidth = math.min(fixedWidth, widget.maxWidth!);
        }
        if (constraints.hasBoundedWidth) {
          fixedWidth = math.min(fixedWidth, constraints.maxWidth);
        }

        final bumpThreshold = (1.0 - (horizontalPadding / fixedWidth)).clamp(
          0.0,
          1.0,
        );

        final isEnabled = !_isAnimating && widget.onChanged != null;

        return SizedBox(
          width: fixedWidth,
          child: InkWell(
            borderRadius: radius,
            onTap: isEnabled
                ? () => widget.onChanged!.call(!widget.value)
                : null,
            child: Container(
              decoration: BoxDecoration(
                color: baseBackground,
                borderRadius: radius,
                border: Border.all(
                  color: AppColors.white,
                  width: 2.r,
                ),
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
                  height: height,
                  child: Stack(
                    children: [
                      Padding(
                        padding: contentPadding,
                        child: Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: buildContentRow(
                            value: _isAnimating ? _fromValue : widget.value,
                            animatedRing: false,
                          ),
                        ),
                      ),
                      if (_isAnimating)
                        Positioned.fill(
                          child: TweenAnimationBuilder<double>(
                            key: ValueKey(_animationSeed),
                            tween: Tween<double>(begin: 0, end: 1),
                            duration: widget.duration,
                            curve: Curves.easeOutCubic,
                            onEnd: () {
                              if (!mounted) return;
                              setState(() {
                                _isAnimating = false;
                                _fromValue = _toValue;
                              });
                            },
                            builder: (context, t, _) {
                              _maybeBumpRing(
                                progress: t,
                                threshold: bumpThreshold,
                              );

                              final direction = Directionality.of(context);
                              final clipper = _FillClipperDirectional(
                                t,
                                textDirection: direction,
                              );

                              return Stack(
                                children: [
                                  ClipRect(
                                    clipper: clipper,
                                    child: SizedBox.expand(
                                      child: ColoredBox(
                                        color: overlayBackground,
                                      ),
                                    ),
                                  ),
                                  ClipRect(
                                    clipper: clipper,
                                    child: Padding(
                                      padding: contentPadding,
                                      child: Align(
                                        alignment:
                                            AlignmentDirectional.centerStart,
                                        child: buildContentRow(
                                          value: _toValue,
                                          animatedRing: true,
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
          ),
        );
      },
    );
  }

  void _maybeBumpRing({
    required double progress,
    required double threshold,
  }) {
    if (_lastRingBumpSeed == _animationSeed) return;
    if (progress < threshold) return;

    _lastRingBumpSeed = _animationSeed;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await _ringController.forward(from: 0);
    });
  }

  String _shownLabelFor(bool value) {
    final rawLabel = value ? widget.onLabel : widget.offLabel;
    return widget.uppercase ? rawLabel.toUpperCase() : rawLabel;
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
        _cachedOnText == onText &&
        _cachedOffText == offText &&
        _cachedStyleHash == styleHash &&
        _cachedTextScaleKey == textScaleKey &&
        _cachedDirection == direction) {
      return;
    }

    final onWidth = _measureTextWidth(
      onText,
      textStyle,
      direction,
      textScaler,
    );
    final offWidth = _measureTextWidth(
      offText,
      textStyle,
      direction,
      textScaler,
    );

    _maxLabelWidth = math.max(onWidth, offWidth);

    _cachedOnText = onText;
    _cachedOffText = offText;
    _cachedStyleHash = styleHash;
    _cachedTextScaleKey = textScaleKey;
    _cachedDirection = direction;
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

class _FillClipperDirectional extends CustomClipper<Rect> {
  const _FillClipperDirectional(
    this.progress, {
    required this.textDirection,
  });

  final double progress;
  final TextDirection textDirection;

  @override
  Rect getClip(Size size) {
    final width = size.width * progress.clamp(0.0, 1.0);

    if (textDirection == TextDirection.rtl) {
      return Rect.fromLTWH(size.width - width, 0, width, size.height);
    }

    return Rect.fromLTWH(0, 0, width, size.height);
  }

  @override
  bool shouldReclip(covariant _FillClipperDirectional oldClipper) {
    return oldClipper.progress != progress ||
        oldClipper.textDirection != textDirection;
  }
}
