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

  void _ensureTimer() {
    // Stop if already done
    if (_isDone) {
      _timer?.cancel();
      _timer = null;
      return;
    }

    // Start if not running
    _timer ??= Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;

      // When it reaches zero, stop ticking
      if (_isDone) {
        _timer?.cancel();
        _timer = null;
      }

      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    _ensureTimer();
  }

  @override
  void didUpdateWidget(covariant DoneCountdownAction oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.endsAt != widget.endsAt) {
      _ensureTimer();
      setState(() {}); // refresh immediately
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _mmss(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
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
