import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxi_driver_app/core/widgets/app_button.dart';

class DoneCountdownAction extends StatefulWidget {
  const DoneCountdownAction({
    required this.prefix,
    required this.label,
    required this.endsAt,
    required this.onDone,
    super.key,
  });

  final String prefix;
  final String label;
  final DateTime endsAt;
  final VoidCallback onDone;

  @override
  State<DoneCountdownAction> createState() => _DoneCountdownActionState();
}

class _DoneCountdownActionState extends State<DoneCountdownAction> {
  Timer? _timer;

  bool get _isDone => !widget.endsAt.isAfter(DateTime.now());

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void didUpdateWidget(covariant DoneCountdownAction oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.endsAt != widget.endsAt) {
      _startTimer();
      setState(() {});
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = null;

    // Stop immediately if countdown already finished.
    if (_isDone) return;

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;

      if (_isDone) {
        _timer?.cancel();
        _timer = null;
      }

      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _mmss(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final leftRaw = widget.endsAt.difference(DateTime.now());
    final left = leftRaw.isNegative ? Duration.zero : leftRaw;

    final canDone = left == Duration.zero;
    final text = canDone ? widget.label : '${widget.prefix} ${_mmss(left)}';

    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: AppButton(
        onPressed: canDone ? widget.onDone : null,
        label: text,
      ),
    );
  }
}
