import 'package:bawabat_al_saeq/app/theme/app_theme_colors.dart';
import 'package:bawabat_al_saeq/app/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TripsCommissionPercentageField extends StatefulWidget {
  const TripsCommissionPercentageField({
    required this.value,
    required this.labelText,
    required this.hintText,
    required this.onChanged,
    super.key,
  });

  final String value;
  final String labelText;
  final String hintText;
  final ValueChanged<String> onChanged;

  @override
  State<TripsCommissionPercentageField> createState() =>
      _TripsCommissionPercentageFieldState();
}

class _TripsCommissionPercentageFieldState
    extends State<TripsCommissionPercentageField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant TripsCommissionPercentageField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.value == _controller.text) return;

    _controller
      ..text = widget.value
      ..selection = TextSelection.collapsed(offset: widget.value.length);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: widget.onChanged,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textInputAction: TextInputAction.done,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
      ],
      style: AppTypography.labelMd.copyWith(
        color: context.colors.textPrimary,
        fontWeight: FontWeight.w800,
      ),
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        suffixText: '%',
        filled: true,
        fillColor: context.colors.surfaceMuted,
        border: _border(context),
        enabledBorder: _border(context),
        focusedBorder: _border(context, isFocused: true),
      ),
    );
  }

  OutlineInputBorder _border(BuildContext context, {bool isFocused = false}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.r),
      borderSide: BorderSide(
        color: isFocused ? context.colors.primary : context.colors.border,
        width: isFocused ? 1.4 : 1,
      ),
    );
  }
}
