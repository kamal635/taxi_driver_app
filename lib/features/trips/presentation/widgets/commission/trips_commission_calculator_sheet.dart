import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/app/theme/app_theme_colors.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/features/trips/domain/entities/completed_offer_entity.dart';
import 'package:bawabat_al_saeq/features/trips/presentation/controllers/completed_offers_controller.dart';
import 'package:bawabat_al_saeq/features/trips/presentation/view_models/trips_commission_view_data.dart';
import 'package:bawabat_al_saeq/features/trips/presentation/widgets/commission/trips_commission_calculator_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TripsCommissionCalculatorSheet extends ConsumerWidget {
  const TripsCommissionCalculatorSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripsState = ref.watch(completedOffersControllerProvider);
    final tripsController = ref.read(
      completedOffersControllerProvider.notifier,
    );
    final offers = tripsState.result?.offers ?? const <CompletedOfferEntity>[];
    final commissionData = TripsCommissionViewData.fromState(
      offers: offers,
      fromDate: tripsState.commissionFromDate,
      toDate: tripsState.commissionToDate,
      percentageText: tripsState.commissionPercentageText,
    );
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.colors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: context.colors.border,
                  borderRadius: BorderRadius.circular(999.r),
                ),
              ),
              AppSpacing.h14,
              TripsCommissionCalculatorCard(
                fromDate: tripsState.commissionFromDate,
                toDate: tripsState.commissionToDate,
                percentageText: tripsState.commissionPercentageText,
                currency: context.l10n.currencySyrianPound,
                selectedTripsCount: commissionData.selectedTripsCount,
                selectedTripsTotalText: commissionData.selectedTripsTotalText,
                commissionAmountText: commissionData.commissionAmountText,
                onFromDateChanged: tripsController.setCommissionFromDate,
                onToDateChanged: tripsController.setCommissionToDate,
                onClearDates: tripsController.clearCommissionDateRange,
                onPercentageChanged:
                    tripsController.setCommissionPercentageText,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
