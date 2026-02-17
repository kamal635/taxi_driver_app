import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/app/theme/app_typography.dart';
import 'package:taxi_driver_app/core/widgets/app_button.dart';

class CurrentRequestCard extends StatelessWidget {
  const CurrentRequestCard._({
    required this.title,
    required this.riderName,
    required this.fareText,
    required this.pickup,
    required this.dropoff,
    required this.variant,
    this.acceptLabel,
    this.rejectLabel,
    this.onAccept,
    this.onReject,
    this.primaryActionLabel,
    this.onPrimaryAction,
    this.countdownPrefix,
    this.doneDelay,
    super.key,
  });

  factory CurrentRequestCard.offer({
    required String title,
    required String riderName,
    required String fareText,
    required String pickup,
    required String dropoff,
    required String acceptLabel,
    required String rejectLabel,
    required VoidCallback onAccept,
    required VoidCallback onReject,
    Key? key,
  }) {
    return CurrentRequestCard._(
      key: key,
      title: title,
      riderName: riderName,
      fareText: fareText,
      pickup: pickup,
      dropoff: dropoff,
      variant: CardVariant.offer,
      acceptLabel: acceptLabel,
      rejectLabel: rejectLabel,
      onAccept: onAccept,
      onReject: onReject,
    );
  }

  factory CurrentRequestCard.current({
    required String title,
    required String riderName,
    required String fareText,
    required String pickup,
    required String dropoff,
    required String primaryActionLabel,
    required VoidCallback onPrimaryAction,
    required String countdownPrefix,
    Duration doneDelay = const Duration(minutes: 5),
    Key? key,
  }) {
    return CurrentRequestCard._(
      key: key,
      title: title,
      riderName: riderName,
      fareText: fareText,
      pickup: pickup,
      dropoff: dropoff,
      variant: CardVariant.current,
      primaryActionLabel: primaryActionLabel,
      onPrimaryAction: onPrimaryAction,
      countdownPrefix: countdownPrefix,
      doneDelay: doneDelay,
    );
  }

  final String title;
  final String riderName;
  final String fareText;
  final String pickup;
  final String dropoff;

  final CardVariant variant;

  // Offer
  final String? acceptLabel;
  final String? rejectLabel;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;

  // Current
  final String? primaryActionLabel;
  final VoidCallback? onPrimaryAction;

  // Countdown (Current)
  final String? countdownPrefix;
  final Duration? doneDelay;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 10),
            color: Colors.black.withValues(alpha: 0.06),
          ),
        ],
      ),

      /// Content
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title, Rider Name, and Avatar
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTypography.subtitleSm),
                    AppSpacing.h4,
                    Text(riderName, style: AppTypography.titleSm),
                  ],
                ),
              ),

              /// Rider Avatar (Placeholder)
              Container(
                width: 42.r,
                height: 42.r,
                decoration: BoxDecoration(
                  color: AppColors.bgBase,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.border),
                ),

                child: Icon(
                  Icons.person_rounded,
                  color: AppColors.iconMuted,
                  size: 22.r,
                ),
              ),
            ],
          ),

          AppSpacing.h12,

          /// Fare
          Text(fareText, style: AppTypography.titleSm),

          AppSpacing.h12,

          /// Pickup
          _Line(icon: Icons.near_me_rounded, text: pickup),

          AppSpacing.h10,

          /// Dropoff
          _Line(icon: Icons.location_on_rounded, text: dropoff),

          AppSpacing.h16,

          if (variant == CardVariant.offer) ...[
            /// Reject Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onReject,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.border),
                      foregroundColor: AppColors.textPrimary,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),
                    child: Text(rejectLabel!, style: AppTypography.labelMd),
                  ),
                ),

                AppSpacing.w12,

                ///  Accept Button
                Expanded(
                  child: AppButton(
                    label: acceptLabel!,
                    onPressed: onAccept,
                  ),
                ),
              ],
            ),
          ] else ...[
            /// Primary Action Button (Done)
            // ✅ Current: Countdown + disabled Done button until timer ends
            _DoneCountdownAction(
              prefix: countdownPrefix ?? 'Available in:',
              label: primaryActionLabel ?? 'Done',
              duration: doneDelay ?? const Duration(minutes: 5),
              onDone: onPrimaryAction ?? () {},
            ),
          ],
        ],
      ),
    );
  }
}

/// The type of the card, which determines which buttons are shown.
enum CardVariant { offer, current }

/// A simple line with an icon and text, used for pickup and dropoff info.
class _Line extends StatelessWidget {
  const _Line({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18.r, color: AppColors.taxiYellow),
        AppSpacing.w8,
        Expanded(child: Text(text, style: AppTypography.bodyMd)),
      ],
    );
  }
}

/// Countdown action: Done button stays disabled (faded) until time is over.
class _DoneCountdownAction extends StatefulWidget {
  const _DoneCountdownAction({
    required this.prefix,
    required this.label,
    required this.duration,
    required this.onDone,
  });

  final String prefix;
  final String label;
  final Duration duration;
  final VoidCallback onDone;
  @override
  State<_DoneCountdownAction> createState() => _DoneCountdownActionState();
}

class _DoneCountdownActionState extends State<_DoneCountdownAction> {
  late Duration _left;
  Timer? _timer;

  bool get _canDone => _left <= Duration.zero;
  @override
  void initState() {
    super.initState();
    _left = widget.duration;

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;

      setState(() {
        _left -= const Duration(seconds: 1);
        if (_left <= Duration.zero) {
          _left = Duration.zero;
          _timer?.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _mmss(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final text = _canDone ? widget.label : '${widget.prefix} ${_mmss(_left)}';

    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: ElevatedButton(
        onPressed: _canDone ? widget.onDone : null,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.taxiYellow,
          foregroundColor: AppColors.textPrimary,
          disabledBackgroundColor: AppColors.taxiYellow.withValues(alpha: 0.35),
          disabledForegroundColor: AppColors.textPrimary.withValues(
            alpha: 0.55,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: AppTypography.button,
        ),
      ),
    );
  }
}
