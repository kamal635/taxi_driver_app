import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/features/trips/domain/entities/completed_offer_entity.dart';
import 'package:bawabat_al_saeq/shared/presentation/widgets/timeline/trip_route_timeline.dart';
import 'package:flutter/material.dart';

class CompletedTripRouteSection extends StatelessWidget {
  const CompletedTripRouteSection({
    required this.offer,
    super.key,
  });

  final CompletedOfferEntity offer;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final pickup = offer.pickup.trim().isEmpty
        ? l10n.unknown
        : offer.pickup.trim();
    final dropoff = _resolveNullableLocation(
      offer.dropoff,
      fallback: l10n.unknown,
    );

    return TripRouteTimeline(
      density: TripRouteTimelineDensity.compact,
      textLayout: TripRouteTimelineTextLayout.inline,
      stops: [
        TripRouteStopData(
          label: l10n.tripsPickupLabel,
          value: pickup,
          type: TripRouteStopType.pickup,
        ),
        TripRouteStopData(
          label: l10n.tripsDropoffLabel,
          value: dropoff,
          type: TripRouteStopType.dropoff,
        ),
      ],
    );
  }

  String _resolveNullableLocation(String? value, {required String fallback}) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return fallback;
    }

    return trimmed;
  }
}
