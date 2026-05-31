import 'package:bawabat_al_saeq/core/constants/app_icons.dart';
import 'package:bawabat_al_saeq/core/extensions/l10n_x.dart';
import 'package:bawabat_al_saeq/features/auth/presentation/validators/login_form_validator.dart';
import 'package:bawabat_al_saeq/shared/presentation/widgets/fields/app_text_field.dart';
import 'package:flutter/material.dart';

class LoginPhoneField extends StatelessWidget {
  const LoginPhoneField({
    required this.controller,
    super.key,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppTextField(
      autofillHints: const [
        AutofillHints.telephoneNumber,
        AutofillHints.username,
      ],
      controller: controller,
      labelText: l10n.phoneLabel,
      hintText: l10n.phoneHint,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      prefixIcon: const Icon(AppIcons.phone),
      validator: (value) => LoginFormValidator.requiredField(
        value,
        message: l10n.validationPhoneRequired,
      ),
    );
  }
}
