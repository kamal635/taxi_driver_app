// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Taxi Driver App';

  @override
  String get brandName => 'Syrian Taxi';

  @override
  String get brandSubtitle => 'Approved drivers platform';

  @override
  String get emailLabel => 'Email Address';

  @override
  String get emailHint => 'example@example.com';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordHint => '••••••••';

  @override
  String get signIn => 'Sign in';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get copyright => '© 2026 Taxi Driver App';

  @override
  String get homeGreeting => 'Hello,';

  @override
  String get homeNetworkConnected => 'Connected';

  @override
  String get homeNetworkDisconnected => 'Disconnected';

  @override
  String get homeAvailabilityOnTitle => 'You are available now';

  @override
  String get homeAvailabilityOnSubtitle =>
      'You will receive nearby ride requests once available';

  @override
  String get homeAvailabilityOffTitle => 'You are offline';

  @override
  String get homeAvailabilityOffSubtitle =>
      'Turn availability on to start receiving nearby ride requests';

  @override
  String get actionConfirm => 'Confirm';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get availabilityTurnOffTitle => 'Turn off availability?';

  @override
  String get availabilityTurnOffMessage =>
      'You will stop receiving ride requests until you turn it on again.';

  @override
  String get homeEmptyTitle => 'Waiting for new requests...';

  @override
  String get homeEmptySubtitle =>
      'We are looking for new riders near your current area. Please stay close to the app.';

  @override
  String get homeUpdateLocation => 'Update location';

  @override
  String get homeTabCurrent => 'Current';

  @override
  String get homeTabCompleted => 'Completed';

  @override
  String get homeRequestNewTitle => 'New request';

  @override
  String get homeRequestCurrentTitle => 'Current ride';

  @override
  String get homeRequestCompletedTitle => 'Completed ride';

  @override
  String get homePickupPrefix => 'Pickup:';

  @override
  String get homeDropoffPrefix => 'Dropoff:';

  @override
  String get homeFarePrefix => 'Fare:';

  @override
  String get homeAvailableIn => 'Available in:';

  @override
  String get actionAccept => 'Accept';

  @override
  String get actionReject => 'Reject';

  @override
  String get actionDone => 'Done';

  @override
  String get badgeNew => 'NEW';

  @override
  String get badgeLive => 'LIVE';

  @override
  String get badgeDone => 'DONE';

  @override
  String get navHome => 'Home';

  @override
  String get navTrips => 'Trips';

  @override
  String get navProfile => 'Profile';

  @override
  String get homeLastLocationUpdateNow => 'Last location update: now';

  @override
  String homeLastLocationUpdateSecondsAgo(int seconds) {
    return 'Last location update: ${seconds}s ago';
  }

  @override
  String get exitAppTitle => 'Exit app?';

  @override
  String get exitAppMessage => 'Are you sure you want to close the app?';

  @override
  String get tripsSummaryTitle => 'Your trips at a glance';

  @override
  String get tripsSummarySubtitle => 'Track completed rides and earnings';

  @override
  String get tripsSummaryTripsLabel => 'Trips';

  @override
  String get tripsSummaryEarningsLabel => 'Earnings';

  @override
  String get tripsFilterAll => 'All';

  @override
  String get tripsFilterToday => 'Today';

  @override
  String get tripsFilterWeek => 'Week';

  @override
  String get tripsRecentTitle => 'Recent completed trips';

  @override
  String get tripsEmptyTitle => 'No trips yet';

  @override
  String get tripsEmptySubtitle =>
      'Completed trips will appear here once you finish your first ride.';

  @override
  String get online => 'Online';

  @override
  String get offline => 'Offline';
}
