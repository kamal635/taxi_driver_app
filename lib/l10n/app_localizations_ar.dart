// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'تطبيق سائق التكسي';

  @override
  String get brandName => 'بوابة السائق';

  @override
  String get brandSubtitle => 'منصة السائقين المعتمدين';

  @override
  String get emailLabel => 'البريد الإلكتروني';

  @override
  String get emailHint => 'example@example.com';

  @override
  String get phoneLabel => 'رقم الهاتف';

  @override
  String get phoneHint => '09xxxxxxxx';

  @override
  String get passwordLabel => 'كلمة المرور';

  @override
  String get passwordHint => '••••••••';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get forgotPassword => 'هل نسيت كلمة المرور؟';

  @override
  String get copyright => '© 2026 تطبيق بوابة السائق';

  @override
  String get legalPrivacyPolicy => 'سياسة الخصوصية';

  @override
  String get legalTermsAndConditions => 'الشروط والأحكام';

  @override
  String get validationPhoneRequired => 'يرجى إدخال رقم الهاتف.';

  @override
  String get validationPasswordRequired => 'يرجى إدخال كلمة المرور.';

  @override
  String get authShowPassword => 'إظهار كلمة المرور';

  @override
  String get authHidePassword => 'إخفاء كلمة المرور';

  @override
  String get notes => 'ملاحظات';

  @override
  String get unknown => 'غير معروف';

  @override
  String get homeGreeting => 'مرحباً،';

  @override
  String get homeNetworkConnected => 'متصل بالشبكة';

  @override
  String get homeNetworkDisconnected => 'غير متصل بالشبكة';

  @override
  String get homeAvailabilityOnTitle => 'أنت متاح الآن';

  @override
  String get homeAvailabilityOnSubtitle =>
      'ستتلقى طلبات الركاب القريبة منك فور توفرها';

  @override
  String get homeAvailabilityOffTitle => 'أنت غير متاح حالياً';

  @override
  String get homeAvailabilityOffSubtitle =>
      'فعّل وضع التوفر لتبدأ باستقبال طلبات الركاب القريبة منك';

  @override
  String get homeEnableAvailabilityAction => 'تفعيل التوفر';

  @override
  String get actionConfirm => 'تأكيد';

  @override
  String get actionCancel => 'إلغاء';

  @override
  String get availabilityTurnOffTitle => 'هل تريد إيقاف التوفر؟';

  @override
  String get availabilityTurnOffMessage =>
      'لن تستقبل طلبات جديدة حتى تقوم بتفعيل التوفر مرة أخرى.';

  @override
  String get availabilityActiveTripOnlineBlocked =>
      'لا يمكنك تفعيل وضع الأونلاين الآن لأن لديك رحلة نشطة. أنهِ الرحلة الحالية أولاً.';

  @override
  String get homeEmptyTitle => 'بانتظار الطلبات الجديدة...';

  @override
  String get homeEmptySubtitle =>
      'نحن نبحث عن ركاب جدد في منطقتك الحالية. يرجى البقاء بالقرب من تطبيقك.';

  @override
  String get homeUpdateLocation => 'تحديث الموقع';

  @override
  String get homeTabCurrent => 'الحالية';

  @override
  String get homeTabCompleted => 'المكتملة';

  @override
  String get homeRequestNewTitle => 'طلب جديد';

  @override
  String get homeRequestCurrentTitle => 'طلب جاري';

  @override
  String get homeRequestCompletedTitle => 'طلب مكتمل';

  @override
  String get homePickupPrefix => 'الانطلاق: ';

  @override
  String get homeDropoffPrefix => 'الوجهة: ';

  @override
  String get homeFarePrefix => 'السعر:';

  @override
  String get homeAvailableIn => 'متاح بعد:';

  @override
  String get actionAccept => 'قبول';

  @override
  String get actionReject => 'رفض';

  @override
  String get actionDone => 'تم';

  @override
  String get badgeNew => 'جديد';

  @override
  String get badgeLive => 'جاري';

  @override
  String get badgeDone => 'تم';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navTrips => 'رحلاتي';

  @override
  String get navProfile => 'ملف شخصي';

  @override
  String get homeLastLocationUpdateNow => 'آخر تحديث للموقع: الآن';

  @override
  String homeLastLocationUpdateSecondsAgo(int seconds) {
    return 'آخر تحديث للموقع: قبل $seconds ثانية';
  }

  @override
  String get exitAppTitle => 'إغلاق التطبيق؟';

  @override
  String get exitAppMessage => 'هل أنت متأكد أنك تريد إغلاق التطبيق؟';

  @override
  String get tripsSummaryTitle => 'نظرة سريعة على أرباحك';

  @override
  String get tripsSummarySubtitle => 'تابع الرحلات المكتملة والأرباح';

  @override
  String get tripsSummaryTripsLabel => 'الرحلات';

  @override
  String get tripsSummaryEarningsLabel => 'الأرباح';

  @override
  String get tripsSummaryAverageFareLabel => 'متوسط قيمة الرحلة';

  @override
  String get tripsFilterAll => 'الكل';

  @override
  String get tripsFilterToday => 'اليوم';

  @override
  String get tripsFilterLast7Days => 'آخر 7 أيام';

  @override
  String get tripsFilterThisMonth => 'هذا الشهر';

  @override
  String get tripsFilterWeek => 'الأسبوع';

  @override
  String get tripsRecentTitle => 'الرحلات المكتملة مؤخراً';

  @override
  String get tripsEmptyTitle => 'لا توجد رحلات بعد';

  @override
  String get tripsEmptySubtitle =>
      'ستظهر الرحلات المكتملة هنا بعد إنهاء أول رحلة.';

  @override
  String get online => 'متصل';

  @override
  String get offline => 'غير متصل';

  @override
  String get profileSectionAccount => 'إعدادات الحساب';

  @override
  String get profileSectionSupport => 'الدعم والمساعدة';

  @override
  String get profileSectionSignOut => 'تسجيل الخروج';

  @override
  String get profileSectionLegal => 'المعلومات القانونية';

  @override
  String get profilePrivacyPolicySubtitle => 'تعرف على كيفية حماية بياناتك';

  @override
  String get profileTermsAndConditionsSubtitle => 'اقرأ شروط استخدام التطبيق';

  @override
  String get profilePasswordUpdatedSuccess => 'تم تحديث كلمة المرور بنجاح.';

  @override
  String get profilePasswordMismatch => 'كلمتا المرور غير متطابقتين.';

  @override
  String get profileEditTitle => 'تعديل الملف الشخصي';

  @override
  String get profileEditSubtitle => 'تحديث معلوماتك الشخصية';

  @override
  String get profileChangePasswordTitle => 'تغيير كلمة المرور';

  @override
  String get profileChangePasswordSubtitle => 'تأمين حسابك بكلمة مرور جديدة';

  @override
  String get profileDarkModeTitle => 'الوضع الليلي';

  @override
  String get profileDarkModeEnabledSubtitle =>
      'مفعّل حالياً، اضغط للتبديل إلى الوضع الفاتح';

  @override
  String get profileDarkModeDisabledSubtitle =>
      'غير مفعّل حالياً، اضغط للتبديل إلى الوضع الداكن';

  @override
  String get profileMyVehiclesTitle => 'مركباتي';

  @override
  String get profileMyVehiclesSubtitle => 'إدارة السيارات المسجلة';

  @override
  String get profileHelpCenterTitle => 'مركز المساعدة';

  @override
  String get profileHelpCenterSubtitle => 'الأسئلة الشائعة والدعم الفني';

  @override
  String get profileSignOutTitle => 'تسجيل الخروج';

  @override
  String get profileSignOutSubtitle => 'الخروج من هذا الحساب';

  @override
  String get signOutConfirmMessage =>
      'لن تستقبل طلبات جديدة بعد تسجيل الخروج. هل تريد المتابعة؟';

  @override
  String get signOutOnlineConfirmMessage =>
      'أنت متاح حالياً لاستقبال الطلبات. سيتم إيقاف التوفر أولاً، ثم تسجيل خروجك. هل تريد المتابعة؟';

  @override
  String get signOutConfirmTitle => 'تسجيل الخروج؟';

  @override
  String get profileChangePhoto => 'تغيير الصورة';

  @override
  String get profileFullName => 'الاسم الكامل';

  @override
  String get profileFullNameHint => 'الاسم الكامل';

  @override
  String get profilePhone => 'رقم الهاتف';

  @override
  String get profilePhoneHint => '+963 123 456 789';

  @override
  String get profileEmail => 'البريد الإلكتروني';

  @override
  String get actionSaveChanges => 'حفظ التغييرات';

  @override
  String get profileCurrentPassword => 'كلمة المرور الحالية';

  @override
  String get profileNewPassword => 'كلمة المرور الجديدة';

  @override
  String get profileConfirmNewPassword => 'تأكيد كلمة المرور الجديدة';

  @override
  String get profilePasswordHint =>
      'يجب أن تحتوي كلمة المرور على 8 أحرف على الأقل.';

  @override
  String get profileUpdatePasswordAction => 'تحديث كلمة المرور';

  @override
  String get vehicleTitle => 'مركبتي';

  @override
  String get vehiclePlateNumberLabel => 'رقم اللوحة';

  @override
  String get vehicleTaxiLanternNumberLabel => 'رقم فانوس التاكسي';

  @override
  String get vehicleModelLabel => 'الموديل';

  @override
  String get vehicleTypeLabel => 'النوع';

  @override
  String get vehicleTypePublic => 'عمومي';

  @override
  String get vehicleTypePrivate => 'خصوصي';

  @override
  String get vehicleInfoNote =>
      'معلومات هذه المركبة مسجّلة في النظام. إذا تغيّر أي تفصيل أو ظهر بشكل غير صحيح، يرجى التواصل مع المكتب.';

  @override
  String tripsTotalTrips(int count) {
    return 'إجمالي الرحلات: ($count)';
  }

  @override
  String get tripsPickupLabel => 'من';

  @override
  String get tripsDropoffLabel => 'إلى';

  @override
  String get errorUnexpected => 'حدث خطأ غير متوقع. حاول مرة أخرى.';

  @override
  String get errorNoInternet =>
      'لا يوجد اتصال بالإنترنت. تأكد من الشبكة وحاول مجددًا.';

  @override
  String get errorTimeout => 'استغرق الطلب وقتًا طويلًا. حاول مرة أخرى.';

  @override
  String get errorCancelled => 'تم إلغاء الطلب.';

  @override
  String get errorAccountLocked => 'حسابك مقفل. الرجاء التواصل مع الإدارة.';

  @override
  String get errorConflict => 'حدث تعارض أثناء العملية. حاول مرة أخرى.';

  @override
  String get errorValidation => 'تأكد من البيانات المدخلة وحاول مجددًا.';

  @override
  String get errorNotFound => 'المورد غير موجود.';

  @override
  String get errorForbidden => 'ليس لديك صلاحية لتنفيذ هذه العملية.';

  @override
  String get errorInvalidCredentials => 'رقم الهاتف أو كلمة المرور غير صحيحة.';

  @override
  String get errorSessionExpired =>
      'انتهت الجلسة. الرجاء تسجيل الدخول من جديد.';

  @override
  String get errorServer => 'مشكلة في السيرفر. حاول لاحقًا.';

  @override
  String get errorBadResponse => 'رد السيرفر غير متوقع. حاول مرة أخرى.';

  @override
  String get authSetupPasswordTitle => 'إنشاء كلمة المرور';

  @override
  String get authSetupPasswordSubtitle =>
      'لإكمال إعداد حسابك، أنشئ كلمة مرور جديدة.';

  @override
  String get authNewPasswordLabel => 'كلمة المرور الجديدة';

  @override
  String get authConfirmNewPasswordLabel => 'تأكيد كلمة المرور';

  @override
  String get authCreatePasswordAction => 'إنشاء كلمة المرور';

  @override
  String get authPasswordRulesHint =>
      'يجب أن تحتوي كلمة المرور على 8 أحرف على الأقل.';

  @override
  String get locationServiceDisabled => 'يرجى تفعيل خدمات الموقع (GPS).';

  @override
  String get locationPermissionRequired =>
      'صلاحية الموقع مطلوبة لتفعيل وضع التوفر.';

  @override
  String get locationPermissionDeniedForever =>
      'تم رفض صلاحية الموقع نهائياً. يرجى تفعيلها من الإعدادات.';

  @override
  String get locationPermissionUnableToDetermine =>
      'تعذّر تحديد صلاحية الموقع. حاول مرة أخرى.';

  @override
  String get locationNetworkError =>
      'لا يوجد اتصال بالإنترنت. لا يمكن تحديث موقعك.';

  @override
  String get availabilityNotificationPermissionRequired =>
      'صلاحية الإشعارات مطلوبة لتفعيل استقبال الطلبات في الخلفية.';

  @override
  String get availabilityBackgroundServiceStartFailed =>
      'تعذّر تشغيل خدمة استقبال الطلبات في الخلفية. حاول مرة أخرى.';

  @override
  String get availabilityBackgroundServiceStopped =>
      'توقفت خدمة استقبال الطلبات. تم تحويلك إلى غير متصل.';

  @override
  String get availabilityRuntimeError =>
      'تعذّر تشغيل وضع التوفر. حاول مرة أخرى.';

  @override
  String get actionSettings => 'الإعدادات';

  @override
  String get todayLabel => 'اليوم';

  @override
  String get yesterdayLabel => 'أمس';

  @override
  String get weekdayMonday => 'الاثنين';

  @override
  String get weekdayTuesday => 'الثلاثاء';

  @override
  String get weekdayWednesday => 'الأربعاء';

  @override
  String get weekdayThursday => 'الخميس';

  @override
  String get weekdayFriday => 'الجمعة';

  @override
  String get weekdaySaturday => 'السبت';

  @override
  String get weekdaySunday => 'الأحد';

  @override
  String get all => 'الكل';

  @override
  String get month => 'الشهر';

  @override
  String get week => 'الاسبوع';

  @override
  String get day => 'اليوم';

  @override
  String get profileAvatarChangePhoto => 'تغيير الصورة';

  @override
  String get profileAvatarRemovePhoto => 'إزالة الصورة';

  @override
  String get profileAvatarPickFromGallery => 'اختيار من المعرض';

  @override
  String get profileAvatarTakePhoto => 'التقاط صورة';

  @override
  String get homeOfferExpiresIn => 'ينتهي خلال:';

  @override
  String get price => 'السعر: ';

  @override
  String get currencySyrianPound => 'ل.س';

  @override
  String get customerPhone => 'رقم الزبون';

  @override
  String get decline => 'رفض';

  @override
  String get tripCompleted => 'اكتملت الرحلة';

  @override
  String get tripProgress => 'الرحلة قيد التقدم...';

  @override
  String get tapToCall => 'اضغط للاتصال بالزبون';

  @override
  String get totalFare => 'الإجرة الإجمالية';

  @override
  String get tripNotes => 'ملاحظات الرحلة';

  @override
  String get timeRemaining => 'الوقت المتبقي للبدء';

  @override
  String get contactSupportLabel => 'تحتاج مساعدة؟';

  @override
  String get contactSupportAction => 'اضغط هنا';

  @override
  String get contactSupportContact => 'للتواصل مع الدعم.';

  @override
  String get appUpdateTitle => 'يوجد تحديث جديد';

  @override
  String appUpdateVersionLabel(String version) {
    return 'الإصدار الجديد: $version';
  }

  @override
  String get appUpdateDownloading => 'جاري تنزيل التحديث...';

  @override
  String appUpdateDownloadingProgress(int progress) {
    return 'جاري التنزيل $progress%';
  }

  @override
  String get appUpdateAction => 'تحديث';

  @override
  String get appUpdateLater => 'لاحقًا';

  @override
  String get appUpdateCancelDownload => 'إلغاء التنزيل';

  @override
  String get appUpdateUrlNotReady => 'رابط التحديث غير جاهز بعد';

  @override
  String get appUpdateDownloadFailed => 'فشل تنزيل التحديث. حاول مرة ثانية.';

  @override
  String get appUpdateInstallFailed =>
      'تعذر بدء التثبيت. إذا فتح لك النظام الإعدادات، فعّل السماح بالتثبيت من هذا المصدر ثم اضغط تحديث مرة ثانية.';

  @override
  String get appUpdateInstalling => 'جاري فتح التثبيت...';

  @override
  String get appUpdateBackgroundStarted => 'بدأ تنزيل التحديث في الخلفية';

  @override
  String get appUpdateInstallerOpening =>
      'تم تنزيل التحديث، سيتم فتح التثبيت الآن';

  @override
  String get appUpdateInvalidPackage => 'الملف المنزّل ليس APK صالحًا';

  @override
  String get profileSectionApp => 'التطبيق';

  @override
  String get profileAppUpdateTitle => 'تحديث التطبيق';

  @override
  String get profileAppUpdateSubtitleChecking => 'جارٍ التحقق من آخر إصدار...';

  @override
  String get profileAppUpdateSubtitleRetry =>
      'تعذر إكمال التحديث. اضغط للمحاولة مرة ثانية.';

  @override
  String get appUpdatePageTitle => 'تحديثات التطبيق';

  @override
  String get appUpdateCheckFailed => 'تعذر التحقق من التحديثات الآن.';

  @override
  String get appUpdateRetryCheck => 'إعادة التحقق';

  @override
  String appUpdateCurrentVersionLabel(String version) {
    return 'الإصدار الحالي: $version';
  }

  @override
  String profileAppUpdateSubtitleAvailable(String version) {
    return 'يوجد إصدار جديد متاح الآن ($version).';
  }

  @override
  String profileAppUpdateSubtitleRequired(String version) {
    return 'يوجد تحديث إجباري متاح ($version).';
  }

  @override
  String profileAppUpdateSubtitleUpToDate(String version) {
    return 'أنت تستخدم آخر إصدار متاح ($version).';
  }

  @override
  String get appUpdateInstallerOpenedHint =>
      'تم فتح مثبت التحديث. أكمل التحديث من شاشة التثبيت الخاصة بالنظام.';

  @override
  String get appUpdateCancel => 'إلغاء التحديث';

  @override
  String get appUpdateReadyToDownload => 'يوجد تحديث جاهز للتنزيل';

  @override
  String get appUpdateDownloadCancelled => 'تم إلغاء تنزيل التحديث';

  @override
  String get profileAppUpdateEntrySubtitle =>
      'تحقق من الإصدار الحالي والتحديثات المتاحة';

  @override
  String get connectionOfflineTitle => 'لا يوجد اتصال بالإنترنت';

  @override
  String get connectionOfflineSubtitle =>
      'سيتم تحديث الطلبات عند عودة الاتصال.';

  @override
  String get connectionRestoredTitle => 'تمت استعادة الاتصال';

  @override
  String get connectionRestoredSubtitle =>
      'يمكنك الآن استقبال التحديثات من جديد.';

  @override
  String get profileAppearanceTitle => 'المظهر';

  @override
  String get profileAppearancePageSubtitle =>
      'اختر طريقة عرض التطبيق المناسبة لك.';

  @override
  String get profileAppearanceSystemTitle => 'حسب إعدادات النظام';

  @override
  String get profileAppearanceSystemSubtitle =>
      'يتبع التطبيق مظهر جهازك تلقائيًا.';

  @override
  String get profileAppearanceLightTitle => 'الوضع الفاتح';

  @override
  String get profileAppearanceLightSubtitle => 'استخدام المظهر الفاتح دائمًا.';

  @override
  String get profileAppearanceDarkTitle => 'الوضع الداكن';

  @override
  String get profileAppearanceDarkSubtitle => 'استخدام المظهر الداكن دائمًا.';

  @override
  String get profileLanguageTitle => 'اللغة';

  @override
  String get profileLanguagePageSubtitle =>
      'اختر اللغة التي تريد استخدامها في التطبيق.';

  @override
  String get profileLanguageArabicSubtitle => 'العربية';

  @override
  String get profileLanguageArabicOptionSubtitle =>
      'استخدام اللغة العربية واتجاه الواجهة من اليمين إلى اليسار.';

  @override
  String get profileLanguageEnglishSubtitle => 'English';

  @override
  String get profileLanguageEnglishOptionSubtitle =>
      'Use English and left-to-right layout.';

  @override
  String get profileLocationStatusTitle => 'حالة الموقع';

  @override
  String get profileLocationStatusSubtitle =>
      'تحقق من إعدادات الموقع اللازمة لاستقبال الطلبات.';

  @override
  String get profileLocationStatusPageSubtitle =>
      'الموقع ضروري لاستقبال الطلبات القريبة منك وتتبع الرحلات أثناء عملك. صلاحية الخلفية اختيارية لتحسين التتبع عند إغلاق التطبيق.';

  @override
  String get locationStatusServiceTitle => 'خدمة الموقع';

  @override
  String get locationStatusServiceEnabled => 'خدمة الموقع مفعّلة على الجهاز.';

  @override
  String get locationStatusServiceDisabled =>
      'خدمة الموقع غير مفعّلة. فعّلها حتى يتمكن التطبيق من تحديد موقعك.';

  @override
  String get locationStatusPermissionTitle => 'صلاحية الموقع';

  @override
  String get locationStatusPermissionAlways => 'الصلاحية ممنوحة دائمًا.';

  @override
  String get locationStatusPermissionWhileInUse =>
      'الصلاحية ممنوحة أثناء استخدام التطبيق، وهذا كافٍ لتفعيل التوفر.';

  @override
  String get locationStatusPermissionDenied => 'صلاحية الموقع غير ممنوحة.';

  @override
  String get locationStatusPermissionDeniedForever =>
      'صلاحية الموقع مرفوضة دائمًا. افتح إعدادات التطبيق لتفعيلها.';

  @override
  String get locationStatusPermissionUnable => 'تعذر تحديد حالة صلاحية الموقع.';

  @override
  String get locationStatusBackgroundTitle => 'الموقع في الخلفية';

  @override
  String get locationStatusBackgroundGranted =>
      'الموقع في الخلفية متاح وجاهز للعمل.';

  @override
  String get locationStatusBackgroundMissing =>
      'اختياري: يمكن تفعيل الموقع في الخلفية لتحسين التتبع عند إغلاق التطبيق.';

  @override
  String get locationStatusReadyTitle => 'الموقع جاهز لاستقبال الطلبات';

  @override
  String get locationStatusNeedsAttentionTitle => 'الموقع يحتاج إلى انتباه';

  @override
  String get locationStatusWhyMessage =>
      'نحتاج إلى الموقع لتحديد الطلبات القريبة منك وتتبع الرحلة بدقة عند التوفر. تشغيل الموقع في الخلفية اختياري.';

  @override
  String get locationStatusRefreshAction => 'تحديث الحالة';

  @override
  String get locationStatusRequestPermissionAction => 'طلب صلاحية الموقع';

  @override
  String get locationStatusOpenAppSettingsAction => 'فتح إعدادات التطبيق';

  @override
  String get locationStatusOpenLocationSettingsAction => 'فتح إعدادات الموقع';

  @override
  String get locationStatusChecking => 'يتم فحص حالة الموقع...';

  @override
  String get locationStatusCheckFailedTitle => 'تعذر فحص حالة الموقع';

  @override
  String get locationStatusCheckFailedSubtitle =>
      'حدث خطأ أثناء فحص إعدادات الموقع. حاول التحديث مرة أخرى.';

  @override
  String get locationBackgroundPermissionRequired =>
      'يمكنك تفعيل صلاحية الموقع في الخلفية لتحسين التتبع، لكنها ليست مطلوبة لتفعيل التوفر.';

  @override
  String get profileAboutTitle => 'حول التطبيق';

  @override
  String get profileAboutSubtitle => 'معلومات التطبيق والروابط المهمة';

  @override
  String get aboutSupportTitle => 'تواصل مع الدعم';

  @override
  String get aboutSupportSubtitle =>
      'احصل على المساعدة أو أرسل استفسارك لفريق الدعم';

  @override
  String get aboutVersionLabel => 'رقم الإصدار';

  @override
  String get aboutVersionUnavailable => 'غير متوفر';

  @override
  String get profileAboutPageSubtitle =>
      'تعرّف على معلومات التطبيق وروابط المساعدة والسياسات.';

  @override
  String get aboutLinksSectionTitle => 'الروابط المهمة';
}
