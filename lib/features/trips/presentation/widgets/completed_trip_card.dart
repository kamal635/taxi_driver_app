import 'package:bawabat_al_saeq/app/theme/app_colors.dart';
import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/core/constants/app_icons.dart';
import 'package:bawabat_al_saeq/features/trips/domain/entities/completed_offer_entity.dart';
import 'package:bawabat_al_saeq/features/trips/presentation/widgets/completed_trip_meta.dart';
import 'package:bawabat_al_saeq/features/trips/presentation/widgets/completed_trip_route_section.dart';
import 'package:bawabat_al_saeq/features/trips/presentation/widgets/trips_card_surface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CompletedTripCard extends StatelessWidget {
  const CompletedTripCard({
    required this.offer,
    super.key,
  });

  final CompletedOfferEntity offer;

  @override
  Widget build(BuildContext context) {
    return TripsCardSurface(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            AppIcons.history,
            size: 26.r,
            color: AppColors.iconMuted,
          ),
          AppSpacing.w8,
          Expanded(child: CompletedTripRouteSection(offer: offer)),
          AppSpacing.w8,
          CompletedTripMeta(offer: offer),
        ],
      ),
    );
  }
}
