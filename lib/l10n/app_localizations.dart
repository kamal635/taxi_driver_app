import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Taxi Driver App'**
  String get appTitle;

  /// No description provided for @brandName.
  ///
  /// In en, this message translates to:
  /// **'Syrian Taxi'**
  String get brandName;

  /// No description provided for @brandSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Approved drivers platform'**
  String get brandSubtitle;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailLabel;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'example@example.com'**
  String get emailHint;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'••••••••'**
  String get passwordHint;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @copyright.
  ///
  /// In en, this message translates to:
  /// **'© 2026 Taxi Driver App'**
  String get copyright;

  /// No description provided for @homeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hello,'**
  String get homeGreeting;

  /// No description provided for @homeNetworkConnected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get homeNetworkConnected;

  /// No description provided for @homeNetworkDisconnected.
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get homeNetworkDisconnected;

  /// No description provided for @homeAvailabilityOnTitle.
  ///
  /// In en, this message translates to:
  /// **'You are available now'**
  String get homeAvailabilityOnTitle;

  /// No description provided for @homeAvailabilityOnSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You will receive nearby ride requests once available'**
  String get homeAvailabilityOnSubtitle;

  /// No description provided for @homeAvailabilityOffTitle.
  ///
  /// In en, this message translates to:
  /// **'You are offline'**
  String get homeAvailabilityOffTitle;

  /// No description provided for @homeAvailabilityOffSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Turn availability on to start receiving nearby ride requests'**
  String get homeAvailabilityOffSubtitle;

  /// No description provided for @actionConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get actionConfirm;

  /// No description provided for @actionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// No description provided for @availabilityTurnOffTitle.
  ///
  /// In en, this message translates to:
  /// **'Turn off availability?'**
  String get availabilityTurnOffTitle;

  /// No description provided for @availabilityTurnOffMessage.
  ///
  /// In en, this message translates to:
  /// **'You will stop receiving ride requests until you turn it on again.'**
  String get availabilityTurnOffMessage;

  /// No description provided for @homeEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Waiting for new requests...'**
  String get homeEmptyTitle;

  /// No description provided for @homeEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'We are looking for new riders near your current area. Please stay close to the app.'**
  String get homeEmptySubtitle;

  /// No description provided for @homeUpdateLocation.
  ///
  /// In en, this message translates to:
  /// **'Update location'**
  String get homeUpdateLocation;

  /// No description provided for @homeTabCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get homeTabCurrent;

  /// No description provided for @homeTabCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get homeTabCompleted;

  /// No description provided for @homeRequestNewTitle.
  ///
  /// In en, this message translates to:
  /// **'New request'**
  String get homeRequestNewTitle;

  /// No description provided for @homeRequestCurrentTitle.
  ///
  /// In en, this message translates to:
  /// **'Current ride'**
  String get homeRequestCurrentTitle;

  /// No description provided for @homeRequestCompletedTitle.
  ///
  /// In en, this message translates to:
  /// **'Completed ride'**
  String get homeRequestCompletedTitle;

  /// No description provided for @homePickupPrefix.
  ///
  /// In en, this message translates to:
  /// **'Pickup:'**
  String get homePickupPrefix;

  /// No description provided for @homeDropoffPrefix.
  ///
  /// In en, this message translates to:
  /// **'Dropoff:'**
  String get homeDropoffPrefix;

  /// No description provided for @homeFarePrefix.
  ///
  /// In en, this message translates to:
  /// **'Fare:'**
  String get homeFarePrefix;

  /// No description provided for @homeAvailableIn.
  ///
  /// In en, this message translates to:
  /// **'Available in:'**
  String get homeAvailableIn;

  /// No description provided for @actionAccept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get actionAccept;

  /// No description provided for @actionReject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get actionReject;

  /// No description provided for @actionDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get actionDone;

  /// No description provided for @badgeNew.
  ///
  /// In en, this message translates to:
  /// **'NEW'**
  String get badgeNew;

  /// No description provided for @badgeLive.
  ///
  /// In en, this message translates to:
  /// **'LIVE'**
  String get badgeLive;

  /// No description provided for @badgeDone.
  ///
  /// In en, this message translates to:
  /// **'DONE'**
  String get badgeDone;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navTrips.
  ///
  /// In en, this message translates to:
  /// **'Trips'**
  String get navTrips;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @homeLastLocationUpdateNow.
  ///
  /// In en, this message translates to:
  /// **'Last location update: now'**
  String get homeLastLocationUpdateNow;

  /// No description provided for @homeLastLocationUpdateSecondsAgo.
  ///
  /// In en, this message translates to:
  /// **'Last location update: {seconds}s ago'**
  String homeLastLocationUpdateSecondsAgo(int seconds);

  /// No description provided for @exitAppTitle.
  ///
  /// In en, this message translates to:
  /// **'Exit app?'**
  String get exitAppTitle;

  /// No description provided for @exitAppMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to close the app?'**
  String get exitAppMessage;

  /// No description provided for @tripsSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Your earnings at a glance'**
  String get tripsSummaryTitle;

  /// No description provided for @tripsSummarySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track completed rides and earnings'**
  String get tripsSummarySubtitle;

  /// No description provided for @tripsSummaryTripsLabel.
  ///
  /// In en, this message translates to:
  /// **'Trips'**
  String get tripsSummaryTripsLabel;

  /// No description provided for @tripsSummaryEarningsLabel.
  ///
  /// In en, this message translates to:
  /// **'Earnings'**
  String get tripsSummaryEarningsLabel;

  /// No description provided for @tripsFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get tripsFilterAll;

  /// No description provided for @tripsFilterToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get tripsFilterToday;

  /// No description provided for @tripsFilterWeek.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get tripsFilterWeek;

  /// No description provided for @tripsRecentTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent completed trips'**
  String get tripsRecentTitle;

  /// No description provided for @tripsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No trips yet'**
  String get tripsEmptyTitle;

  /// No description provided for @tripsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Completed trips will appear here once you finish your first ride.'**
  String get tripsEmptySubtitle;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// No description provided for @profileSectionAccount.
  ///
  /// In en, this message translates to:
  /// **'Account settings'**
  String get profileSectionAccount;

  /// No description provided for @profileSectionSupport.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get profileSectionSupport;

  /// No description provided for @profileSectionSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get profileSectionSignOut;

  /// No description provided for @profileEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get profileEditTitle;

  /// No description provided for @profileEditSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update your personal info'**
  String get profileEditSubtitle;

  /// No description provided for @profileChangePasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get profileChangePasswordTitle;

  /// No description provided for @profileChangePasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Secure your account'**
  String get profileChangePasswordSubtitle;

  /// No description provided for @profileMyVehiclesTitle.
  ///
  /// In en, this message translates to:
  /// **'My vehicles'**
  String get profileMyVehiclesTitle;

  /// No description provided for @profileMyVehiclesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your registered cars'**
  String get profileMyVehiclesSubtitle;

  /// No description provided for @profileHelpCenterTitle.
  ///
  /// In en, this message translates to:
  /// **'Help center'**
  String get profileHelpCenterTitle;

  /// No description provided for @profileHelpCenterSubtitle.
  ///
  /// In en, this message translates to:
  /// **'FAQs and technical support'**
  String get profileHelpCenterSubtitle;

  /// No description provided for @profileSignOutTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get profileSignOutTitle;

  /// No description provided for @profileSignOutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign out from this account'**
  String get profileSignOutSubtitle;

  /// No description provided for @signOutConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out from this account?'**
  String get signOutConfirmMessage;

  /// No description provided for @signOutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign out?'**
  String get signOutConfirmTitle;

  /// No description provided for @profileChangePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change photo'**
  String get profileChangePhoto;

  /// No description provided for @profileFullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get profileFullName;

  /// No description provided for @profileFullNameHint.
  ///
  /// In en, this message translates to:
  /// **'John Doe'**
  String get profileFullNameHint;

  /// No description provided for @profilePhone.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get profilePhone;

  /// No description provided for @profilePhoneHint.
  ///
  /// In en, this message translates to:
  /// **'+963 123 456 789'**
  String get profilePhoneHint;

  /// No description provided for @profileEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get profileEmail;

  /// No description provided for @actionSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get actionSaveChanges;

  /// No description provided for @profileCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get profileCurrentPassword;

  /// No description provided for @profileNewPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get profileNewPassword;

  /// No description provided for @profileConfirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get profileConfirmNewPassword;

  /// No description provided for @profilePasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters.'**
  String get profilePasswordHint;

  /// No description provided for @profileUpdatePasswordAction.
  ///
  /// In en, this message translates to:
  /// **'Update password'**
  String get profileUpdatePasswordAction;

  /// No description provided for @vehicleTitle.
  ///
  /// In en, this message translates to:
  /// **'My Vehicle'**
  String get vehicleTitle;

  /// No description provided for @vehiclePlateNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Plate Number'**
  String get vehiclePlateNumberLabel;

  /// No description provided for @vehicleTaxiLanternNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Taxi Lantern Number'**
  String get vehicleTaxiLanternNumberLabel;

  /// No description provided for @vehicleModelLabel.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get vehicleModelLabel;

  /// No description provided for @vehicleTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get vehicleTypeLabel;

  /// No description provided for @vehicleTypePublic.
  ///
  /// In en, this message translates to:
  /// **'Public'**
  String get vehicleTypePublic;

  /// No description provided for @vehicleTypePrivate.
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get vehicleTypePrivate;

  /// No description provided for @vehicleInfoNote.
  ///
  /// In en, this message translates to:
  /// **'This vehicle information is registered in the system. If any details change or appear incorrect, please contact the office or your coordinator.'**
  String get vehicleInfoNote;

  /// No description provided for @tripsTotalTrips.
  ///
  /// In en, this message translates to:
  /// **'total trips: ({count})'**
  String tripsTotalTrips(int count);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
