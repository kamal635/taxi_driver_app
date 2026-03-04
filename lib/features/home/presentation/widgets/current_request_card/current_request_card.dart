import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/app/theme/app_typography.dart';
import 'package:taxi_driver_app/core/constants/app_icons.dart';
import 'package:taxi_driver_app/core/widgets/app_button.dart';
import 'package:taxi_driver_app/features/home/presentation/widgets/current_request_card/done_countdown_action.dart';
import 'package:taxi_driver_app/features/home/presentation/widgets/current_request_card/phone_row.dart';
import 'package:taxi_driver_app/features/home/presentation/widgets/current_request_card/request_line.dart';
import 'package:taxi_driver_app/features/home/presentation/widgets/current_request_card/request_notes_card.dart';
import 'package:taxi_driver_app/features/home/presentation/widgets/current_request_card/request_status_badge.dart';

enum CardVariant { offer, accepte }

class CurrentRequestCard extends StatelessWidget {
  const CurrentRequestCard._({
    required this.badgeTitle,
    required this.priceText,
    required this.pickup,
    required this.dropoff,
    required this.variant,
    this.isLoading = false,
    this.isNotes = false,
    this.acceptLabel,
    this.rejectLabel,
    this.onAccept,
    this.onReject,
    this.primaryActionLabel,
    this.onPrimaryAction,
    this.countdownPrefix,
    this.endsAt,
    this.phoneNumber,
    super.key,
  });

  factory CurrentRequestCard.offer({
    required String badgeTitle,
    required String priceText,
    required String pickup,
    required String dropoff,
    required bool isLoading,
    required String acceptLabel,
    required String rejectLabel,
    required VoidCallback? onAccept,
    required VoidCallback? onReject,
    Key? key,
  }) {
    return CurrentRequestCard._(
      key: key,
      badgeTitle: badgeTitle,
      priceText: priceText,
      pickup: pickup,
      isLoading: isLoading,
      dropoff: dropoff,
      variant: CardVariant.offer,
      acceptLabel: acceptLabel,
      rejectLabel: rejectLabel,
      onAccept: onAccept,
      onReject: onReject,
    );
  }

  factory CurrentRequestCard.accepted({
    required String badgeTitle,
    required String priceText,
    required String pickup,
    required String dropoff,
    required String phoneNumber,
    required String primaryActionLabel,
    required VoidCallback onPrimaryAction,
    required String countdownPrefix,
    required bool isNotes,
    required DateTime? endsAt,
    Key? key,
  }) {
    return CurrentRequestCard._(
      key: key,
      badgeTitle: badgeTitle,
      isNotes: isNotes,
      priceText: priceText,
      pickup: pickup,
      dropoff: dropoff,
      phoneNumber: phoneNumber,
      variant: CardVariant.accepte,
      primaryActionLabel: primaryActionLabel,
      onPrimaryAction: onPrimaryAction,
      countdownPrefix: countdownPrefix,
      endsAt: endsAt,
    );
  }

  final String priceText;
  final String pickup;
  final String dropoff;

  final CardVariant variant;
  final String badgeTitle;

  final String? acceptLabel;
  final String? rejectLabel;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;

  final String? primaryActionLabel;
  final VoidCallback? onPrimaryAction;

  final String? countdownPrefix;
  final DateTime? endsAt;

  final String? phoneNumber;

  final bool isNotes;

  final bool isLoading;
  bool get _isOffer => variant == CardVariant.offer;

  @override
  Widget build(BuildContext context) {
    final dir = Directionality.of(context) == TextDirection.ltr;

    return Column(
      children: [
        Container(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header ( Status)
              Align(
                alignment: dir
                    ? AlignmentGeometry.topRight
                    : AlignmentGeometry.topLeft,
                child: RequestStatusBadge(
                  variant: variant,
                  badgeTitle: badgeTitle,
                ),
              ),

              AppSpacing.h16,

              // Fare
              Text(priceText, style: AppTypography.titleSm),

              AppSpacing.h12,

              // Pickup
              RequestLine(icon: AppIcons.pickup, text: pickup),

              AppSpacing.h10,

              // Dropoff
              RequestLine(icon: AppIcons.dropoff, text: dropoff),

              AppSpacing.h16,

              // Phone section (only current)
              if (!_isOffer) ...[
                const Divider(
                  color: AppColors.border,
                ),
                AppSpacing.h12,
                PhoneRow(phoneNumber: phoneNumber ?? ''),
                AppSpacing.h16,
              ],

              // Actions
              if (_isOffer)
                _OfferActions(
                  acceptLabel: acceptLabel ?? '',
                  rejectLabel: rejectLabel ?? '',
                  onAccept: onAccept,
                  onReject: onReject,
                  isLoading: isLoading,
                )
              else
                (endsAt == null)
                    ? AppButton(
                        onPressed: onPrimaryAction ?? () {},
                        label: primaryActionLabel ?? 'Done',
                      )
                    : DoneCountdownAction(
                        prefix: countdownPrefix ?? 'Available in:',
                        label: primaryActionLabel ?? 'Done',
                        endsAt: endsAt!,
                        onDone: onPrimaryAction ?? () {},
                      ),
            ],
          ),
        ),
        if (!_isOffer && isNotes) ...[
          AppSpacing.h10,
          const RequestNotesCard(notes: 'اذا ممكن يكون طبون السيارة فاضي'),
        ],
      ],
    );
  }
}

class _OfferActions extends StatelessWidget {
  const _OfferActions({
    required this.isLoading,
    required this.acceptLabel,
    required this.rejectLabel,
    required this.onAccept,
    required this.onReject,
  });

  final String acceptLabel;
  final String rejectLabel;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppButton(
            backgroundColor: AppColors.bgBase,
            isLoading: isLoading,
            onPressed: onReject,
            label: rejectLabel,
          ),
        ),
        AppSpacing.w12,
        Expanded(
          child: AppButton(
            isLoading: isLoading,
            onPressed: onAccept,
            label: acceptLabel,
          ),
        ),
      ],
    );
  }
}
