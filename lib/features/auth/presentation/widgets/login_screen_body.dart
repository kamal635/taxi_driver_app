import 'package:bawabat_al_saeq/features/auth/presentation/widgets/login_footer.dart';
import 'package:bawabat_al_saeq/features/auth/presentation/widgets/login_form.dart';
import 'package:bawabat_al_saeq/features/auth/presentation/widgets/login_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreenBody extends StatelessWidget {
  const LoginScreenBody({
    required this.phoneController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onTogglePasswordVisibility,
    required this.isLoading,
    required this.onSubmit,
    super.key,
  });

  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onTogglePasswordVisibility;
  final bool isLoading;
  final VoidCallback? onSubmit;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const LoginHeader(),
                    LoginForm(
                      phoneController: phoneController,
                      passwordController: passwordController,
                      obscurePassword: obscurePassword,
                      onTogglePasswordVisibility: onTogglePasswordVisibility,
                      isLoading: isLoading,
                      onSubmit: onSubmit,
                    ),
                  ],
                ),
                const LoginFooter(),
              ],
            ),
          ),
        );
      },
    );
  }
}
