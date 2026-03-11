import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/app/theme/app_typography.dart';
import 'package:taxi_driver_app/core/constants/app_icons.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';
import 'package:taxi_driver_app/core/utils/price_formatter.dart';

class HeaderOfferCard extends StatefulWidget {
  const HeaderOfferCard({
    required this.statusOffer,
    required this.totalFare,
    required this.expiresAt,
    this.isExpiresAt = false,
    super.key,
  });

  final String statusOffer;
  final DateTime? expiresAt;
  final String totalFare;
  final bool isExpiresAt;

  @override
  State<HeaderOfferCard> createState() => _HeaderOfferCardState();
}

class _HeaderOfferCardState extends State<HeaderOfferCard> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimerIfNeeded();
  }

  @override
  void didUpdateWidget(covariant HeaderOfferCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.expiresAt != widget.expiresAt ||
        oldWidget.isExpiresAt != widget.isExpiresAt) {
      _startTimerIfNeeded();
    }
  }

  void _startTimerIfNeeded() {
    _timer?.cancel();
    _timer = null;

    if (!widget.isExpiresAt) return;

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;

      final remaining = widget.expiresAt!.difference(DateTime.now());
      if (remaining <= Duration.zero) {
        _timer?.cancel();
        _timer = null;
      }

      setState(() {});
    });
  }

  String _mmss(Duration duration) {
    final safe = duration.isNegative ? Duration.zero : duration;
    final minutes = safe.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = safe.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String _expiryText() {
    final expiresAt = widget.expiresAt;

    final remaining = expiresAt!.difference(DateTime.now());
    return 'Expires in ${_mmss(remaining)}';
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
              padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
              decoration: BoxDecoration(
                color: AppColors.infoBg,
                borderRadius: BorderRadius.circular(999.r),
              ),
              child: Text(
                widget.statusOffer,
                style: AppTypography.labelMd.copyWith(
                  color: AppColors.info,
                ),
              ),
            ),
            if (widget.isExpiresAt)
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
                      _expiryText(),
                      style: AppTypography.labelSm.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ],
                ),
              )
            else
              const SizedBox(),
          ],
        ),
        AppSpacing.h18,
        Text(l10n.totalFare, style: AppTypography.subtitleSm),
        AppSpacing.h4,
        Text(
          '${formatOrderPrice(widget.totalFare)} SYP',
          style: AppTypography.titleMd,
        ),
      ],
    );
  }
}
