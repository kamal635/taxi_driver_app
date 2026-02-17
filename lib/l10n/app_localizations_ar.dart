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
}
