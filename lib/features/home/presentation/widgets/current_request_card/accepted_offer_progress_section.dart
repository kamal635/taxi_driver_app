import 'dart:async';

import 'package:flutter/material.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/features/home/presentation/widgets/current_request_card/accpeted_offer_time_remaining.dart';
import 'package:taxi_driver_app/features/home/presentation/widgets/current_request_card/action_accepted_offer.dart';

class AcceptedOfferProgressSection extends StatefulWidget {
  const AcceptedOfferProgressSection({
    required this.cooldownUntil,
    required this.actionCompletedOffer,
    super.key,
  });

  final DateTime cooldownUntil;
  final VoidCallback? actionCompletedOffer;

  @override
  State<AcceptedOfferProgressSection> createState() =>
      _AcceptedOfferProgressSectionState();
}

class _AcceptedOfferProgressSectionState
    extends State<AcceptedOfferProgressSection> {
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
  void didUpdateWidget(covariant AcceptedOfferProgressSection oldWidget) {
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
        TimeRemainingBar(
          remaining: _remaining,
          progress: _progress,
        ),

        AppSpacing.h24,

        ActionCompletedOffer(
          canComplete: _canComplete,
          actionCompletedOffer: widget.actionCompletedOffer,
        ),
      ],
    );
  }
}
