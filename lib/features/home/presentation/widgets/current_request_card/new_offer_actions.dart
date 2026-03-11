import 'package:flutter/material.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';
import 'package:taxi_driver_app/core/widgets/app_button.dart';

class NewOfferActions extends StatelessWidget {
  const NewOfferActions({
    required this.isLoadingAccepte,
    required this.isLoadingDecline,
    super.key,
    this.accepteOffer,
    this.declineOffer,
  });

  final VoidCallback? accepteOffer;
  final VoidCallback? declineOffer;
  final bool isLoadingAccepte;
  final bool isLoadingDecline;
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: AppButton(
            borderColor: AppColors.error,
            labelColor: AppColors.error,
            backgroundColor: Colors.transparent,
            label: l10n.decline,
            onPressed: declineOffer,
            isLoading: isLoadingDecline,
          ),
        ),

        AppSpacing.w8,

        Expanded(
          flex: 3,
          child: AppButton(
            isLoading: isLoadingAccepte,
            label: l10n.actionAccept,
            onPressed: accepteOffer,
          ),
        ),
      ],
    );
  }
}
