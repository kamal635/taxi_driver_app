import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/core/constants/app_icons.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';
import 'package:taxi_driver_app/core/utils/price_formatter.dart';
import 'package:taxi_driver_app/features/trips/domain/entities/completed_offer_entity.dart';
import 'package:taxi_driver_app/features/trips/presentation/formatters/completed_trip_time_formatter.dart';
import 'package:taxi_driver_app/features/trips/presentation/widgets/completed_trip_card.dart';
import 'package:taxi_driver_app/features/trips/presentation/widgets/trips_empty_state.dart';
import 'package:taxi_driver_app/features/trips/presentation/widgets/trips_loading_state.dart';

class TripsContentSection extends StatelessWidget {
  const TripsContentSection({
    required this.offers,
    required this.isInitialLoading,
    required this.isRefreshing,
    super.key,
  });

  final List<CompletedOfferEntity> offers;
  final bool isInitialLoading;
  final bool isRefreshing;

  @override
  Widget build(BuildContext context) {
    if (isInitialLoading) {
      return const TripsLoadingState();
    }

    if (offers.isEmpty) {
      return TripsEmptyState(
        icon: AppIcons.car,
        title: context.l10n.tripsEmptyTitle,
        subtitle: context.l10n.tripsEmptySubtitle,
      );
    }

    return Column(
      children: [
        if (isRefreshing)
          Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: const LinearProgressIndicator(
              color: AppColors.primary,
              minHeight: 3,
            ),
          ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: offers.length,
          separatorBuilder: (_, _) => AppSpacing.h12,
          itemBuilder: (context, index) {
            final offer = offers[index];

            return CompletedTripCard(
              placeTitle: offer.pickup,
              timeText: CompletedTripTimeFormatter.format(
                context,
                offer.updatedAt,
              ),
              fareText: 'SYP ${formatOrderPrice(offer.price)}',
              onTap: () {
                // Open trip details later.
              },
            );
          },
        ),
      ],
    );
  }
}
