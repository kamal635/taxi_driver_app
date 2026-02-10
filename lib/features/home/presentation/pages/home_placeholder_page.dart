import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePlaceholderPage extends StatelessWidget {
  const HomePlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home', style: TextStyle(fontSize: 16.sp)),
      ),
      body: Center(
        child: Text('Home Placeholder', style: TextStyle(fontSize: 18.sp)),
      ),
    );
  }
}
