import 'dart:async';

import 'package:flutter/material.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/features/home/presentation/widgets/current_request_card/accepted_actions.dart';
import 'package:taxi_driver_app/features/home/presentation/widgets/current_request_card/accpeted_progress_ui.dart';

class AcceptedProgressTimer extends StatefulWidget {
  const AcceptedProgressTimer({
    required this.cooldownUntil,
    required this.actionCompletedOffer,
    super.key,
  });

  final DateTime cooldownUntil;
  final VoidCallback? actionCompletedOffer;

  @override
  State<AcceptedProgressTimer> createState() => _AcceptedProgressTimerState();
}

class _AcceptedProgressTimerState extends State<AcceptedProgressTimer> {
  static const Duration _totalDuration = Duration(minutes: 5);

  Timer? _timer;

  Duration get _remaining {
    final diff = widget.cooldownUntil.difference(DateTime.now());
    return diff.isNegative ? Duration.zero : diff;
  }

  bool get _canComplete => _remaining == Duration.zero;

  double get _progress {
    final totalMs = _totalDuration.inMilliseconds;
    final remainingMs = _remaining.inMilliseconds.clamp(0, totalMs);
    return totalMs == 0 ? 0.0 : remainingMs / totalMs;
  }

  @override
  void initState() {
    super.initState();
    _startTimerIfNeeded();
  }

  @override
  void didUpdateWidget(covariant AcceptedProgressTimer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.cooldownUntil != widget.cooldownUntil) {
      _startTimerIfNeeded();
    }
  }

  void _startTimerIfNeeded() {
    _timer?.cancel();
    _timer = null;

    if (_remaining == Duration.zero) {
      if (mounted) setState(() {});
      return;
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
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
    return Column(
      children: [
        AccpetedProgressUi(
          remaining: _remaining,
          progress: _progress,
        ),

        AppSpacing.h24,

        AcceptedActions(
          canComplete: _canComplete,
          actionCompletedOffer: widget.actionCompletedOffer,
        ),
      ],
    );
  }
}
