import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/features/home/presentation/widgets/offers/accepted/accepted_actions.dart';
import 'package:bawabat_al_saeq/features/home/presentation/widgets/offers/accepted/accepted_progress_indicator.dart';
import 'package:bawabat_al_saeq/shared/presentation/widgets/builders/countdown_builder.dart';
import 'package:flutter/material.dart';

/// Handles the cooldown timer before the driver can complete the trip.
class AcceptedProgressTimer extends StatelessWidget {
  const AcceptedProgressTimer({
    required this.cooldownUntil,
    required this.isCompletedLoading,
    this.onComplete,
    super.key,
  });

  static const Duration _totalDuration = Duration(minutes: 5);

  final DateTime cooldownUntil;
  final VoidCallback? onComplete;
  final bool isCompletedLoading;

  @override
  Widget build(BuildContext context) {
    return CountdownBuilder(
      targetTime: cooldownUntil,
      builder: (context, remaining) {
        final canComplete = remaining == Duration.zero;
        final progress = _progressFromRemaining(remaining);

        return Column(
          children: [
            AcceptedProgressIndicator(
              remaining: remaining,
              progress: progress,
            ),
            AppSpacing.h24,
            AcceptedActions(
              isCompletedLoading: isCompletedLoading,
              canComplete: canComplete,
              onComplete: onComplete,
            ),
          ],
        );
      },
    );
  }

  double _progressFromRemaining(Duration remaining) {
    final totalMilliseconds = _totalDuration.inMilliseconds;
    final elapsedMilliseconds = totalMilliseconds - remaining.inMilliseconds;

    return (elapsedMilliseconds / totalMilliseconds).clamp(0.0, 1.0);
  }
}
