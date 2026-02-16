import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxi_driver_app/app/theme/app_colors.dart';
import 'package:taxi_driver_app/features/auth/presentation/widgets/login_footer.dart';
import 'package:taxi_driver_app/features/auth/presentation/widgets/login_form.dart';
import 'package:taxi_driver_app/features/auth/presentation/widgets/login_header.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.5,
            colors: [AppColors.bgWarm, AppColors.bgBase],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                /// Header with logo and titles
                const LoginHeader(),

                LoginForm(
                  emailController: TextEditingController(),
                  passwordController: TextEditingController(),
                  obscurePassword: true,
                  onTogglePasswordVisibility: () {},
                ),

                /// Footer widget for the login page,
                /// showing copyright information
                const LoginFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
