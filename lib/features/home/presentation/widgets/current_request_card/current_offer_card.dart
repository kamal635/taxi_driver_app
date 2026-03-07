import 'package:flutter/material.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/app/theme/app_typography.dart';
import 'package:taxi_driver_app/core/constants/app_icons.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';
import 'package:taxi_driver_app/core/widgets/app_button.dart';
import 'package:taxi_driver_app/features/home/presentation/widgets/current_request_card/done_countdown_action.dart';
import 'package:taxi_driver_app/features/home/presentation/widgets/current_request_card/new_offer_actions_row.dart';
import 'package:taxi_driver_app/features/home/presentation/widgets/current_request_card/offer_card_surface.dart';
import 'package:taxi_driver_app/features/home/presentation/widgets/current_request_card/offer_card_variant.dart';
import 'package:taxi_driver_app/features/home/presentation/widgets/current_request_card/offer_expiry_countdown.dart';
import 'package:taxi_driver_app/features/home/presentation/widgets/current_request_card/offer_info_row.dart';
import 'package:taxi_driver_app/features/home/presentation/widgets/current_request_card/offer_notes_card.dart';
import 'package:taxi_driver_app/features/home/presentation/widgets/current_request_card/offer_status_badge.dart';
import 'package:taxi_driver_app/features/home/presentation/widgets/current_request_card/phone_row.dart';

class CurrentOfferCard extends StatelessWidget {
  const CurrentOfferCard._({
    required this.badgeTitle,
    required this.priceText,
    required this.pickup,
    required this.dropoff,
    required this.variant,
    this.isLoading = false,
    this.isNotes = false,
    this.notes,
    this.acceptLabel,
    this.rejectLabel,
    this.onAccept,
    this.onReject,
    this.primaryActionLabel,
    this.onPrimaryAction,
    this.countdownPrefix,
    this.endsAt,
    this.phoneNumber,
    this.offerExpiresAt,
    this.offerExpiresPrefix,
    this.onOfferExpired,
    super.key,
  });

  factory CurrentOfferCard.offer({
    required String badgeTitle,
    required String priceText,
    required String pickup,
    required String dropoff,
    required bool isLoading,
    required String acceptLabel,
    required String rejectLabel,
    required VoidCallback? onAccept,
    required VoidCallback? onReject,
    required DateTime expiresAt,
    required String expiresPrefix,
    required VoidCallback onExpired,
    Key? key,
  }) {
    return CurrentOfferCard._(
      key: key,
      badgeTitle: badgeTitle,
      priceText: priceText,
      pickup: pickup,
      dropoff: dropoff,
      variant: CardVariant.offer,
      isLoading: isLoading,
      acceptLabel: acceptLabel,
      rejectLabel: rejectLabel,
      onAccept: onAccept,
      onReject: onReject,
      offerExpiresAt: expiresAt,
      offerExpiresPrefix: expiresPrefix,
      onOfferExpired: onExpired,
    );
  }

  factory CurrentOfferCard.accepted({
    required String badgeTitle,
    required String priceText,
    required String pickup,
    required String dropoff,
    required String phoneNumber,
    required String primaryActionLabel,
    required VoidCallback onPrimaryAction,
    required String countdownPrefix,
    required bool isNotes,
    required String notes,
    required DateTime? endsAt,
    Key? key,
  }) {
    return CurrentOfferCard._(
      key: key,
      badgeTitle: badgeTitle,
      priceText: priceText,
      pickup: pickup,
      dropoff: dropoff,
      variant: CardVariant.accepted,
      phoneNumber: phoneNumber,
      primaryActionLabel: primaryActionLabel,
      onPrimaryAction: onPrimaryAction,
      countdownPrefix: countdownPrefix,
      endsAt: endsAt,
      isNotes: isNotes,
      notes: notes,
    );
  }

  final String badgeTitle;
  final String priceText;
  final String pickup;
  final String dropoff;
  final CardVariant variant;

  final bool isLoading;
  final bool isNotes;
  final String? notes;

  final String? acceptLabel;
  final String? rejectLabel;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;

  final String? primaryActionLabel;
  final VoidCallback? onPrimaryAction;

  final String? countdownPrefix;
  final DateTime? endsAt;

  final String? phoneNumber;

  final DateTime? offerExpiresAt;
  final String? offerExpiresPrefix;
  final VoidCallback? onOfferExpired;

  bool get _isOffer => variant == CardVariant.offer;

  @override
  Widget build(BuildContext context) {
    final offerExpired =
        _isOffer &&
        offerExpiresAt != null &&
        !offerExpiresAt!.isAfter(DateTime.now());
    final l10n = context.l10n;

    final isRtl = Directionality.of(context) == TextDirection.rtl;
    return Column(
      children: [
        OfferCardSurface(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: isRtl
                    ? AlignmentDirectional.topEnd
                    : AlignmentDirectional.topStart,
                child: OfferStatusBadge(
                  variant: variant,
                  badgeTitle: badgeTitle,
                ),
              ),
              AppSpacing.h16,
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: l10n.price, style: AppTypography.titleSm),
                    TextSpan(
                      text: priceText,
                      style: AppTypography.titleSm.copyWith(
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
              ),

              AppSpacing.h12,
              OfferInfoRow(
                icon: AppIcons.pickup,
                text: pickup,
                prefixInfo: l10n.homePickupPrefix,
              ),
              AppSpacing.h10,
              OfferInfoRow(
                prefixInfo: l10n.homeDropoffPrefix,
                icon: AppIcons.dropoff,
                text: dropoff,
              ),
              AppSpacing.h16,
              if (_isOffer && offerExpiresAt != null) ...[
                OfferExpiryCountdown(
                  expiresAt: offerExpiresAt!,
                  prefix: offerExpiresPrefix ?? 'Expires in:',
                  onExpired: onOfferExpired,
                ),
                AppSpacing.h12,
              ],
              if (!_isOffer) ...[
                const Divider(color: AppColors.border),
                AppSpacing.h12,
                PhoneRow(phoneNumber: phoneNumber ?? ''),
                AppSpacing.h16,
              ],
              if (_isOffer)
                NewOfferActionsRow(
                  enabled: !offerExpired,
                  isLoading: isLoading,
                  acceptLabel: acceptLabel ?? '',
                  rejectLabel: rejectLabel ?? '',
                  onAccept: onAccept,
                  onReject: onReject,
                )
              else
                _AcceptedAction(
                  endsAt: endsAt,
                  primaryActionLabel: primaryActionLabel,
                  countdownPrefix: countdownPrefix,
                  onPrimaryAction: onPrimaryAction,
                ),
            ],
          ),
        ),
        if (!_isOffer && isNotes) ...[
          AppSpacing.h10,
          OfferNotesCard(notes: notes),
        ],
      ],
    );
  }
}

class _AcceptedAction extends StatelessWidget {
  const _AcceptedAction({
    required this.endsAt,
    required this.primaryActionLabel,
    required this.countdownPrefix,
    required this.onPrimaryAction,
  });

  final DateTime? endsAt;
  final String? primaryActionLabel;
  final String? countdownPrefix;
  final VoidCallback? onPrimaryAction;

  @override
  Widget build(BuildContext context) {
    if (endsAt == null) {
      return AppButton(
        onPressed: onPrimaryAction,
        label: primaryActionLabel ?? 'Done',
      );
    }

    return DoneCountdownAction(
      prefix: countdownPrefix ?? 'Available in:',
      label: primaryActionLabel ?? 'Done',
      endsAt: endsAt!,
      onDone: onPrimaryAction ?? () {},
    );
  }
}
