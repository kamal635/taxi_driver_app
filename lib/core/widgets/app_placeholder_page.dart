import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppPlaceholderPage extends StatelessWidget {
  const AppPlaceholderPage({
    required this.title,
    super.key,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: TextStyle(fontSize: 16.sp)),
      ),
      body: Center(
        child: Text(
          '$title (Placeholder)',
          style: TextStyle(fontSize: 18.sp),
        ),
      ),
    );
  }
}
