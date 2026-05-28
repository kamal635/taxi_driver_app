// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Bawabat Al Saeq App';

  @override
  String get brandName => 'Bawabat Al Saeq';

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
  String get copyright => '© 2026 Bawabat Al Saeq App';

  @override
  String get legalPrivacyPolicy => 'Privacy Policy';

  @override
  String get legalTermsAndConditions => 'Terms & Conditions';

  @override
  String get validationPhoneRequired => 'Please enter your phone number.';

  @override
  String get validationPasswordRequired => 'Please enter your password.';

  @override
  String get authShowPassword => 'Show password';

  @override
  String get authHidePassword => 'Hide password';

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
  String get availabilityActiveTripOnlineBlocked =>
      'You can\'t go online right now because you have an active trip. Finish the current trip first.';

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
  String get homePickupPrefix => 'PICKUP: ';

  @override
  String get homeDropoffPrefix => 'DROPOFF: ';

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
  String get profileSectionLegal => 'Legal information';

  @override
  String get profilePrivacyPolicySubtitle => 'Learn how your data is protected';

  @override
  String get profileTermsAndConditionsSubtitle => 'Read the app terms of use';

  @override
  String get profilePasswordUpdatedSuccess => 'Password updated successfully.';

  @override
  String get profilePasswordMismatch => 'Passwords do not match.';

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
    return 'Total trips: ($count)';
  }

  @override
  String get tripsPickupLabel => 'From';

  @override
  String get tripsDropoffLabel => 'To';

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
  String get availabilityNotificationPermissionRequired =>
      'Notification permission is required to receive ride requests in the background.';

  @override
  String get availabilityBackgroundServiceStartFailed =>
      'Unable to start background request service. Please try again.';

  @override
  String get availabilityBackgroundServiceStopped =>
      'Request receiving service stopped. You have been set offline.';

  @override
  String get availabilityRuntimeError =>
      'Unable to start availability mode. Please try again.';

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
  String get currencySyrianPound => 'SYP';

  @override
  String get customerPhone => 'CUSTOMER PHONE';

  @override
  String get decline => 'Decline';

  @override
  String get tripCompleted => 'Trip is Completed';

  @override
  String get tripProgress => 'Trip in Progress..';

  @override
  String get tapToCall => 'Tap to call customer';

  @override
  String get totalFare => 'TOTAL FARE';

  @override
  String get tripNotes => 'TRIP NOTES';

  @override
  String get timeRemaining => 'Time remaining to start';

  @override
  String get contactSupportLabel => 'Need help?';

  @override
  String get contactSupportAction => 'Tap here';

  @override
  String get contactSupportContact => 'Contact support.';

  @override
  String get appUpdateTitle => 'New update available';

  @override
  String appUpdateVersionLabel(String version) {
    return 'New version: $version';
  }

  @override
  String get appUpdateDownloading => 'Downloading update...';

  @override
  String appUpdateDownloadingProgress(int progress) {
    return 'Downloading $progress%';
  }

  @override
  String get appUpdateAction => 'Update';

  @override
  String get appUpdateLater => 'Later';

  @override
  String get appUpdateCancelDownload => 'Cancel download';

  @override
  String get appUpdateUrlNotReady => 'The update link is not ready yet.';

  @override
  String get appUpdateDownloadFailed =>
      'Failed to download the update. Please try again.';

  @override
  String get appUpdateInstallFailed =>
      'Couldn\'t start the installation. If the system opened Settings, allow installs from this source, then tap Update again.';

  @override
  String get appUpdateInstalling => 'Opening installer...';

  @override
  String get appUpdateBackgroundStarted =>
      'Update download started in the background';

  @override
  String get appUpdateInstallerOpening =>
      'Update downloaded. Opening installer now';

  @override
  String get appUpdateInvalidPackage =>
      'The downloaded file is not a valid APK';

  @override
  String get profileSectionApp => 'App';

  @override
  String get profileAppUpdateTitle => 'App update';

  @override
  String get profileAppUpdateSubtitleChecking =>
      'Checking for the latest version...';

  @override
  String get profileAppUpdateSubtitleRetry =>
      'Could not complete the update. Tap to try again.';

  @override
  String get appUpdatePageTitle => 'App updates';

  @override
  String get appUpdateCheckFailed => 'Could not check for updates right now.';

  @override
  String get appUpdateRetryCheck => 'Check again';

  @override
  String appUpdateCurrentVersionLabel(String version) {
    return 'Current version: $version';
  }

  @override
  String profileAppUpdateSubtitleAvailable(String version) {
    return 'A new version is available now ($version).';
  }

  @override
  String profileAppUpdateSubtitleRequired(String version) {
    return 'A required update is available ($version).';
  }

  @override
  String profileAppUpdateSubtitleUpToDate(String version) {
    return 'You are using the latest available version ($version).';
  }

  @override
  String get appUpdateInstallerOpenedHint =>
      'The installer has been opened. Complete the update from the system installer screen.';

  @override
  String get appUpdateCancel => 'Cancel update';

  @override
  String get appUpdateReadyToDownload => 'An update is ready to download';

  @override
  String get appUpdateDownloadCancelled => 'Update download was cancelled';

  @override
  String get profileAppUpdateEntrySubtitle =>
      'Check the current version and available updates';
}
