import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:smooth/src/build_after_previous_build_or_layout.dart';
import 'package:smooth/src/time_budget.dart';

class Smooth extends StatelessWidget {
  final Widget? placeholder;
  final Widget child;

  const Smooth({
    super.key,
    this.placeholder,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BuildAfterPreviousBuildOrLayout(
      child: _SmoothCore(
        placeholder: placeholder,
        child: child,
      ),
    );
  }
}

class _SmoothCore extends StatefulWidget {
  final Widget? placeholder;
  final Widget child;

  const _SmoothCore({
    required this.placeholder,
    required this.child,
  });

  @override
  State<_SmoothCore> createState() => _SmoothCoreState();
}

class _SmoothCoreState extends State<_SmoothCore> {
  Widget? previousChild;

  @override
  Widget build(BuildContext context) {
    // In *normal* cases, we should not put non-pure logic inside `build`.
    // But we are hacking here, and it is safe - see readme for more details.
    if (BaseTimeBudget.instance.timeSufficient) {
      previousChild = widget.child;
      return widget.child;
    } else {
      SchedulerBinding.instance.addPostFrameCallback((_) => setState(() {}));
      return widget.placeholder ?? previousChild ?? const SizedBox();
    }
  }
}
