import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/app/theme/app_theme_colors.dart';
import 'package:bawabat_al_saeq/app/theme/app_typography.dart';
import 'package:bawabat_al_saeq/core/constants/app_icons.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/core/utils/price_formatter.dart';
import 'package:bawabat_al_saeq/features/home/presentation/formatters/offer_time_formatter.dart';
import 'package:bawabat_al_saeq/shared/presentation/widgets/builders/countdown_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Header area shared by offer cards.
class OfferHeader extends StatelessWidget {
  const OfferHeader({
    required this.statusLabel,
    required this.totalFare,
    this.expiresAt,
    this.showExpiryChip = false,
    super.key,
  });

  final String statusLabel;
  final DateTime? expiresAt;
  final String totalFare;
  final bool showExpiryChip;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OfferStatusChip(label: statusLabel),
            if (showExpiryChip && expiresAt != null)
              OfferExpiryChip(expiresAt: expiresAt!),
          ],
        ),
        AppSpacing.h18,
        Text(l10n.totalFare, style: AppTypography.subtitleSm),
        AppSpacing.h4,
        Text(
          '${formatOrderPrice(totalFare)} ${l10n.currencySyrianPound}',
          style: AppTypography.titleMd,
        ),
      ],
    );
  }
}

class OfferStatusChip extends StatelessWidget {
  const OfferStatusChip({
    required this.label,
    super.key,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 14.w),
      decoration: BoxDecoration(
        color: colors.infoBg,
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Text(
        label,
        style: AppTypography.labelMd.copyWith(color: colors.info),
      ),
    );
  }
}

class OfferExpiryChip extends StatelessWidget {
  const OfferExpiryChip({
    required this.expiresAt,
    super.key,
  });

  final DateTime expiresAt;

  @override
  Widget build(BuildContext context) {
    return CountdownBuilder(
      targetTime: expiresAt,
      builder: (context, remaining) {
        return _OfferExpiryChipContent(
          label:
              '${context.l10n.homeOfferExpiresIn} '
              '${formatOfferCountdown(remaining)}',
        );
      },
    );
  }
}

class _OfferExpiryChipContent extends StatelessWidget {
  const _OfferExpiryChipContent({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
      decoration: BoxDecoration(
        color: colors.errorBg.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Row(
        children: [
          Icon(
            AppIcons.timer,
            size: 18.r,
            color: colors.error,
          ),
          AppSpacing.w4,
          Text(
            label,
            style: AppTypography.labelSm.copyWith(color: colors.error),
          ),
        ],
      ),
    );
  }
}
