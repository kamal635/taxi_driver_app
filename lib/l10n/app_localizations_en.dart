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
  String get phoneLabel => 'Phone Number';

  @override
  String get phoneHint => '09xxxxxxxx';

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
  String get notes => 'Notes';

  @override
  String get unknown => 'unknown';

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
  String get homePickupPrefix => 'Pickup: ';

  @override
  String get homeDropoffPrefix => 'Dropoff: ';

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
  String get tripsSummaryTitle => 'Your earnings at a glance';

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

  @override
  String get profileSectionAccount => 'Account settings';

  @override
  String get profileSectionSupport => 'Support';

  @override
  String get profileSectionSignOut => 'Sign out';

  @override
  String get profileEditTitle => 'Edit profile';

  @override
  String get profileEditSubtitle => 'Update your personal info';

  @override
  String get profileChangePasswordTitle => 'Change password';

  @override
  String get profileChangePasswordSubtitle => 'Secure your account';

  @override
  String get profileMyVehiclesTitle => 'My vehicles';

  @override
  String get profileMyVehiclesSubtitle => 'Manage your registered cars';

  @override
  String get profileHelpCenterTitle => 'Help center';

  @override
  String get profileHelpCenterSubtitle => 'FAQs and technical support';

  @override
  String get profileSignOutTitle => 'Sign out';

  @override
  String get profileSignOutSubtitle => 'Sign out from this account';

  @override
  String get signOutConfirmMessage =>
      'Are you sure you want to sign out from this account?';

  @override
  String get signOutConfirmTitle => 'Sign out?';

  @override
  String get profileChangePhoto => 'Change photo';

  @override
  String get profileFullName => 'Full name';

  @override
  String get profileFullNameHint => 'John Doe';

  @override
  String get profilePhone => 'Phone number';

  @override
  String get profilePhoneHint => '+963 123 456 789';

  @override
  String get profileEmail => 'Email';

  @override
  String get actionSaveChanges => 'Save changes';

  @override
  String get profileCurrentPassword => 'Current password';

  @override
  String get profileNewPassword => 'New password';

  @override
  String get profileConfirmNewPassword => 'Confirm new password';

  @override
  String get profilePasswordHint => 'Password must be at least 8 characters.';

  @override
  String get profileUpdatePasswordAction => 'Update password';

  @override
  String get vehicleTitle => 'My Vehicle';

  @override
  String get vehiclePlateNumberLabel => 'Plate Number';

  @override
  String get vehicleTaxiLanternNumberLabel => 'Taxi Lantern Number';

  @override
  String get vehicleModelLabel => 'Model';

  @override
  String get vehicleTypeLabel => 'Type';

  @override
  String get vehicleTypePublic => 'Public';

  @override
  String get vehicleTypePrivate => 'Private';

  @override
  String get vehicleInfoNote =>
      'This vehicle information is registered in the system. If any details change or appear incorrect, please contact the office.';

  @override
  String tripsTotalTrips(int count) {
    return 'total trips: ($count)';
  }

  @override
  String get errorUnexpected => 'Something went wrong. Please try again.';

  @override
  String get errorNoInternet =>
      'No internet connection. Check your network and try again.';

  @override
  String get errorTimeout => 'The request took too long. Please try again.';

  @override
  String get errorCancelled => 'Request cancelled.';

  @override
  String get errorAccountLocked =>
      'Your account is locked. Please contact support.';

  @override
  String get errorConflict => 'A conflict occurred. Please try again.';

  @override
  String get errorValidation => 'Please check your input and try again.';

  @override
  String get errorNotFound => 'Resource not found.';

  @override
  String get errorForbidden =>
      'You don\'t have permission to perform this action.';

  @override
  String get errorInvalidCredentials =>
      'Phone number or password is incorrect.';

  @override
  String get errorSessionExpired => 'Session expired. Please sign in again.';

  @override
  String get errorServer => 'Server error. Please try again later.';

  @override
  String get errorBadResponse =>
      'Unexpected server response. Please try again.';

  @override
  String get authSetupPasswordTitle => 'Create password';

  @override
  String get authSetupPasswordSubtitle =>
      'To finish setting up your account, create a new password.';

  @override
  String get authNewPasswordLabel => 'New password';

  @override
  String get authConfirmNewPasswordLabel => 'Confirm new password';

  @override
  String get authCreatePasswordAction => 'Create password';

  @override
  String get authPasswordRulesHint => 'Password must be at least 8 characters.';

  @override
  String get locationServiceDisabled => 'Please enable Location Services.';

  @override
  String get locationPermissionRequired =>
      'Location permission is required to go online.';

  @override
  String get locationPermissionDeniedForever =>
      'Location permission is permanently denied. Please enable it from Settings.';

  @override
  String get locationPermissionUnableToDetermine =>
      'Unable to determine location permission. Please try again.';

  @override
  String get locationNetworkError =>
      'No internet connection. We can\'t update your location.';

  @override
  String get actionSettings => 'Settings';

  @override
  String get todayLabel => 'Today';

  @override
  String get yesterdayLabel => 'Yesterday';

  @override
  String get weekdayMonday => 'Monday';

  @override
  String get weekdayTuesday => 'Tuesday';

  @override
  String get weekdayWednesday => 'Wednesday';

  @override
  String get weekdayThursday => 'Thursday';

  @override
  String get weekdayFriday => 'Friday';

  @override
  String get weekdaySaturday => 'Saturday';

  @override
  String get weekdaySunday => 'Sunday';

  @override
  String get all => 'All';

  @override
  String get month => 'Month';

  @override
  String get week => 'Week';

  @override
  String get day => 'Day';

  @override
  String get profileAvatarChangePhoto => 'Change photo';

  @override
  String get profileAvatarRemovePhoto => 'Remove photo';

  @override
  String get profileAvatarPickFromGallery => 'Choose from gallery';

  @override
  String get profileAvatarTakePhoto => 'Take a photo';

  @override
  String get homeOfferExpiresIn => 'Expires in:';

  @override
  String get price => 'Price: ';

  @override
  String get customerPhone => 'CUSTOMER PHONE';

  @override
  String get tripCompleted => 'Trip Completed';
}
