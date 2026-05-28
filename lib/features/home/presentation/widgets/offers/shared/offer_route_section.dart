import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/shared/presentation/widgets/timeline/trip_route_timeline.dart';
import 'package:flutter/material.dart';

/// Shared pickup/dropoff UI used inside offer cards.
class OfferRouteSection extends StatelessWidget {
  const OfferRouteSection({
    required this.pickup,
    required this.dropoff,
    super.key,
  });

  final String pickup;
  final String? dropoff;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final resolvedPickup = pickup.trim().isEmpty ? l10n.unknown : pickup.trim();
    final resolvedDropoff = _resolveNullableLocation(
      dropoff,
      fallback: l10n.unknown,
    );

    return TripRouteTimeline(
      stops: [
        TripRouteStopData(
          label: l10n.homePickupPrefix,
          value: resolvedPickup,
          type: TripRouteStopType.pickup,
        ),
        TripRouteStopData(
          label: l10n.homeDropoffPrefix,
          value: resolvedDropoff,
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
