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
  String get brandName => 'التكسي السوري';

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
  String get copyright => '© 2026 تطبيق سائق التكسي';

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
  String get actionConfirm => 'تأكيد';

  @override
  String get actionCancel => 'إلغاء';

  @override
  String get availabilityTurnOffTitle => 'هل تريد إيقاف التوفر؟';

  @override
  String get availabilityTurnOffMessage =>
      'لن تستقبل طلبات جديدة حتى تقوم بتفعيل التوفر مرة أخرى.';

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
  String get homePickupPrefix => 'الانطلاق:';

  @override
  String get homeDropoffPrefix => 'الوجهة:';

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
  String get tripsFilterAll => 'الكل';

  @override
  String get tripsFilterToday => 'اليوم';

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
  String get profileEditTitle => 'تعديل الملف الشخصي';

  @override
  String get profileEditSubtitle => 'تحديث معلوماتك الشخصية';

  @override
  String get profileChangePasswordTitle => 'تغيير كلمة المرور';

  @override
  String get profileChangePasswordSubtitle => 'تأمين حسابك بكلمة مرور جديدة';

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
      'هل أنت متأكد أنك تريد تسجيل الخروج من هذا الحساب؟';

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
}
