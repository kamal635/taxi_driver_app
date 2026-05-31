import 'dart:async';

import 'package:flutter/material.dart';

/// Rebuilds only its small subtree while counting down to [targetTime].
///
/// Use it for offer timers or any lightweight countdown UI instead of putting
/// a Timer in a large page/card widget.
class CountdownBuilder extends StatefulWidget {
  const CountdownBuilder({
    required this.targetTime,
    required this.builder,
    this.tick = const Duration(seconds: 1),
    super.key,
  });

  final DateTime targetTime;
  final Duration tick;
  final Widget Function(BuildContext context, Duration remaining) builder;

  @override
  State<CountdownBuilder> createState() => _CountdownBuilderState();
}

class _CountdownBuilderState extends State<CountdownBuilder> {
  Timer? _timer;

  Duration get _remaining {
    final difference = widget.targetTime.difference(DateTime.now());
    return difference.isNegative ? Duration.zero : difference;
  }

  @override
  void initState() {
    super.initState();
    _startTimerIfNeeded();
  }

  @override
  void didUpdateWidget(covariant CountdownBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.targetTime != widget.targetTime ||
        oldWidget.tick != widget.tick) {
      _startTimerIfNeeded();
    }
  }

  void _startTimerIfNeeded() {
    _timer?.cancel();
    _timer = null;

    if (_remaining == Duration.zero) {
      return;
    }

    _timer = Timer.periodic(widget.tick, (_) {
      if (!mounted) return;

      if (_remaining == Duration.zero) {
        _timer?.cancel();
        _timer = null;
      }

      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _remaining);
  }
}
