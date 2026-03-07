import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/app/theme/app_typography.dart';
import 'package:taxi_driver_app/core/constants/app_icons.dart';

class OfferExpiryCountdown extends StatefulWidget {
  const OfferExpiryCountdown({
    required this.expiresAt,
    required this.prefix,
    this.onExpired,
    super.key,
  });

  final DateTime expiresAt;
  final String prefix;
  final VoidCallback? onExpired;

  @override
  State<OfferExpiryCountdown> createState() => _OfferExpiryCountdownState();
}

class _OfferExpiryCountdownState extends State<OfferExpiryCountdown> {
  Timer? _timer;
  bool _notifiedExpired = false;

  bool get _isExpired => !widget.expiresAt.isAfter(DateTime.now());

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void didUpdateWidget(covariant OfferExpiryCountdown oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.expiresAt != widget.expiresAt) {
      _notifiedExpired = false;
      _startTimer();
      setState(() {});
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = null;

    // Notify once if the offer is already expired.
    if (_isExpired) {
      _notifyExpiredOnce();
      return;
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;

      if (_isExpired) {
        _timer?.cancel();
        _timer = null;
        _notifyExpiredOnce();
      }

      setState(() {});
    });
  }

  void _notifyExpiredOnce() {
    if (_notifiedExpired) return;
    _notifiedExpired = true;
    widget.onExpired?.call();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _mmss(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final leftRaw = widget.expiresAt.difference(DateTime.now());
    final left = leftRaw.isNegative ? Duration.zero : leftRaw;
    final isExpired = left == Duration.zero;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      child: Row(
        children: [
          Icon(
            AppIcons.timer,
            size: 18.r,
            color: isExpired ? AppColors.error : AppColors.iconMuted,
          ),
          AppSpacing.w8,
          Expanded(
            child: Text(
              isExpired ? 'Expired' : '${widget.prefix} ${_mmss(left)}',
              style: AppTypography.subtitleSm.copyWith(
                color: isExpired ? AppColors.error : AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
