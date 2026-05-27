import 'dart:async';

import 'package:bawabat_al_saeq/app/theme/app_colors.dart';
import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/app/theme/app_typography.dart';
import 'package:bawabat_al_saeq/core/constants/app_icons.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/core/utils/price_formatter.dart';
import 'package:bawabat_al_saeq/features/home/presentation/utils/offer_time_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Header area shared by pending and accepted offer cards.
class OfferHeader extends StatefulWidget {
  const OfferHeader({
    required this.statusLabel,
    required this.totalFare,
    required this.expiresAt,
    this.showExpiryChip = false,
    super.key,
  });

  final String statusLabel;
  final DateTime? expiresAt;
  final String totalFare;
  final bool showExpiryChip;

  @override
  State<OfferHeader> createState() => _OfferHeaderState();
}

class _OfferHeaderState extends State<OfferHeader> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimerIfNeeded();
  }

  @override
  void didUpdateWidget(covariant OfferHeader oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.expiresAt != widget.expiresAt ||
        oldWidget.showExpiryChip != widget.showExpiryChip) {
      _startTimerIfNeeded();
    }
  }

  void _startTimerIfNeeded() {
    _timer?.cancel();
    _timer = null;

    if (!widget.showExpiryChip || widget.expiresAt == null) return;

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;

      if (remainingUntil(widget.expiresAt!) == Duration.zero) {
        _timer?.cancel();
        _timer = null;
      }

      setState(() {});
    });
  }

  String _buildExpiryText(BuildContext context) {
    final expiresAt = widget.expiresAt;
    if (expiresAt == null) return '';

    return '${context.l10n.homeOfferExpiresIn} '
        '${formatOfferCountdown(remainingUntil(expiresAt))}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 14.w),
              decoration: BoxDecoration(
                color: AppColors.infoBg,
                borderRadius: BorderRadius.circular(999.r),
              ),
              child: Text(
                widget.statusLabel,
                style: AppTypography.labelMd.copyWith(color: AppColors.info),
              ),
            ),
            if (widget.showExpiryChip)
              Container(
                padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
                decoration: BoxDecoration(
                  color: AppColors.errorBg.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      AppIcons.timer,
                      size: 18.r,
                      color: AppColors.error,
                    ),
                    AppSpacing.w4,
                    Text(
                      _buildExpiryText(context),
                      style: AppTypography.labelSm.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        AppSpacing.h18,
        Text(l10n.totalFare, style: AppTypography.subtitleSm),
        AppSpacing.h4,
        Text(
          '${formatOrderPrice(widget.totalFare)} ${l10n.currencySyrianPound}',
          style: AppTypography.titleMd,
        ),
      ],
    );
  }
}
