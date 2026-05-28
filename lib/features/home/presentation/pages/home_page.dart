import 'package:bawabat_al_saeq/app/theme/app_spacing.dart';
import 'package:bawabat_al_saeq/features/home/presentation/listeners/home_action_feedback_listener.dart';
import 'package:bawabat_al_saeq/features/home/presentation/widgets/home_offer_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              AppSpacing.h16,
              const Expanded(
                child: _HomeScrollBody(),
              ),
            ],
          ),
        ),
        const HomeActionFeedbackListener(),
      ],
    );
  }
}

class _HomeScrollBody extends StatelessWidget {
  const _HomeScrollBody();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: const HomeOfferSection(),
          ),
        );
      },
    );
  }
}
