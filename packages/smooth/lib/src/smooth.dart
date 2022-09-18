import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:smooth/src/build_after_previous_build_or_layout.dart';
import 'package:smooth/src/time_budget.dart';

class Smooth extends StatelessWidget {
  final String? debugName;
  final Widget? emptyPlaceholder;
  final Widget child;

  const Smooth({
    super.key,
    this.debugName,
    this.emptyPlaceholder,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BuildAfterPreviousBuildOrLayout(
      child: _SmoothCore(
        debugName: debugName,
        emptyPlaceholder: emptyPlaceholder,
        child: child,
      ),
    );
  }
}

class _SmoothCore extends StatefulWidget {
  final String? debugName;
  final Widget? emptyPlaceholder;
  final Widget child;

  const _SmoothCore({
    required this.debugName,
    required this.emptyPlaceholder,
    required this.child,
  });

  @override
  State<_SmoothCore> createState() => _SmoothCoreState();
}

class _SmoothCoreState extends State<_SmoothCore> {
  Widget? previousChild;

  @override
  Widget build(BuildContext context) {
    print(
        '$runtimeType.build[${widget.debugName}] now=${DateTime.now()} sufficient=${BaseTimeBudget.instance.timeSufficient}');

    // In *normal* cases, we should not put non-pure logic inside `build`.
    // But we are hacking here, and it is safe - see readme for more details.
    if (BaseTimeBudget.instance.timeSufficient) {
      previousChild = widget.child;
      return widget.child;
    } else {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() {});
      });

      return previousChild ?? widget.emptyPlaceholder ?? const SizedBox(height: 48);
    }
  }
}
