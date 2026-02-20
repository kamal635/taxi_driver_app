import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxi_driver_app/app/theme/app_spacing.dart';
import 'package:taxi_driver_app/app/theme/app_typography.dart';
import 'package:taxi_driver_app/core/extensions/l10n_x.dart';
import 'package:taxi_driver_app/features/trips/presentation/models/trip_ui.dart';
import 'package:taxi_driver_app/features/trips/presentation/widgets/trip_card.dart';
import 'package:taxi_driver_app/features/trips/presentation/widgets/trips_empty_state.dart';
import 'package:taxi_driver_app/features/trips/presentation/widgets/trips_filters.dart';
import 'package:taxi_driver_app/features/trips/presentation/widgets/trips_summary_card.dart';

enum TripsFilterUi { all, today, week }

class TripsPage extends StatefulWidget {
  const TripsPage({super.key});

  @override
  State<TripsPage> createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> {
  TripsFilterUi _filter = TripsFilterUi.all;

  // UI-only demo list (later from provider)
  static const List<TripUi> _allTrips = [
    TripUi(
      placeTitle: 'Al-Jamarek Area',
      timeText: 'Today 10:30 AM',
      fareText: '12,000 SYP',
    ),
    TripUi(
      placeTitle: 'Abu Romaneh',
      timeText: 'Yesterday 09:15 PM',
      fareText: '18,500 SYP',
    ),
    TripUi(
      placeTitle: 'Baramkeh',
      timeText: 'Yesterday 07:05 PM',
      fareText: '9,000 SYP',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final trips = _filteredTrips(_allTrips, _filter);

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        16.w,
        8.h,
        16.w,
        90.h,
      ), // space for bottom nav
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TripsSummaryCard(
            title: l10n.tripsSummaryTitle,
            tripsLabel: l10n.tripsSummaryTripsLabel,
            earningsLabel: l10n.tripsSummaryEarningsLabel,
            tripsCountText: '3', // UI-only
            earningsText: '39,500 SYP', // UI-only
          ),

          AppSpacing.h12,

          TripsFilters(
            selected: _filter,
            allLabel: l10n.tripsFilterAll,
            todayLabel: l10n.tripsFilterToday,
            weekLabel: l10n.tripsFilterWeek,
            onChanged: (v) => setState(() => _filter = v),
          ),

          AppSpacing.h18,

          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                l10n.tripsRecentTitle,
                style: AppTypography.titleSm,
              ),
              AppSpacing.w8,
              Expanded(
                child: Text(
                  l10n.tripsTotalTrips(10),
                  style: AppTypography.subtitleSm,
                ),
              ),
            ],
          ),

          AppSpacing.h12,

          if (trips.isEmpty)
            TripsEmptyState(
              icon: Icons.directions_car_rounded,
              title: l10n.tripsEmptyTitle,
              subtitle: l10n.tripsEmptySubtitle,
            )
          else
            ...trips.map(
              (t) => Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: TripCard(
                  placeTitle: t.placeTitle,
                  timeText: t.timeText,
                  fareText: t.fareText,
                  onTap: () {
                    // later: open details page
                  },
                ),
              ),
            ),

          AppSpacing.h12,
        ],
      ),
    );
  }

  List<TripUi> _filteredTrips(List<TripUi> list, TripsFilterUi filter) {
    // UI-only demo logic
    switch (filter) {
      case TripsFilterUi.all:
        return list;
      case TripsFilterUi.today:
        return list.isEmpty ? const [] : [list.first];
      case TripsFilterUi.week:
        return list.length <= 2 ? list : list.sublist(0, 2);
    }
  }
}
