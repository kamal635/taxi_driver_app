import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final class AppSpacing {
  static SizedBox h(double value) => SizedBox(height: value.h);
  static SizedBox w(double value) => SizedBox(width: value.w);

  static SizedBox get h4 => h(4);
  static SizedBox get h6 => h(6);
  static SizedBox get h8 => h(8);
  static SizedBox get h10 => h(10);
  static SizedBox get h12 => h(12);
  static SizedBox get h14 => h(14);
  static SizedBox get h16 => h(16);
  static SizedBox get h18 => h(18);
  static SizedBox get h24 => h(24);
  static SizedBox get h32 => h(32);

  static SizedBox get w4 => w(4);
  static SizedBox get w6 => w(6);
  static SizedBox get w8 => w(8);
  static SizedBox get w10 => w(10);
  static SizedBox get w12 => w(12);
  static SizedBox get w16 => w(16);
}
