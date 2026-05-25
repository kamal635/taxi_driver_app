import 'dart:async';

import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/features/home/presentation/widgets/offers/accepted/accepted_actions.dart';
import 'package:bawabat_al_saeq/features/home/presentation/widgets/offers/accepted/accepted_progress_indicator.dart';
import 'package:flutter/material.dart';

/// Handles the cooldown timer before the driver can complete the trip.
class AcceptedProgressTimer extends StatefulWidget {
  const AcceptedProgressTimer({
    required this.cooldownUntil,
    required this.isCompletedLoading,
    this.onComplete,
    super.key,
  });

  final DateTime cooldownUntil;
  final VoidCallback? onComplete;
  final bool isCompletedLoading;

  @override
  State<AcceptedProgressTimer> createState() => _AcceptedProgressTimerState();
}

class _AcceptedProgressTimerState extends State<AcceptedProgressTimer> {
  static const Duration _totalDuration = Duration(minutes: 5);

  Timer? _timer;

  Duration get _remaining {
    final difference = widget.cooldownUntil.difference(DateTime.now());
    return difference.isNegative ? Duration.zero : difference;
  }

  bool get _canComplete => _remaining == Duration.zero;

  double get _progress {
    final totalMilliseconds = _totalDuration.inMilliseconds;
    final remainingMilliseconds = _remaining.inMilliseconds.clamp(
      0,
      totalMilliseconds,
    );
    return totalMilliseconds == 0
        ? 0.0
        : remainingMilliseconds / totalMilliseconds;
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
        AcceptedProgressIndicator(
          remaining: _remaining,
          progress: _progress,
        ),
        AppSpacing.h24,
        AcceptedActions(
          isCompletedLoading: widget.isCompletedLoading,
          canComplete: _canComplete,
          onComplete: widget.onComplete,
        ),
      ],
    );
  }
}
