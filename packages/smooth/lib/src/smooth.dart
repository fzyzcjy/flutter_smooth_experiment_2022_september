import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:smooth/src/build_after_previous_build_or_layout.dart';
import 'package:smooth/src/time_budget.dart';

class Smooth extends StatefulWidget {
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
  State<Smooth> createState() => _SmoothState();
}

class _SmoothState extends State<Smooth> {
  Widget? previousChild;

  @override
  Widget build(BuildContext context) {
    // print(
    //     '$runtimeType.build.outside[${widget.debugName}] now=${DateTime.now()} sufficient=${BaseTimeBudget.instance.timeSufficient}');

    return BuildAfterPreviousBuildOrLayout(builder: (context) {
      // print(
      //     '$runtimeType.build.inside[${widget.debugName}] now=${DateTime.now()} sufficient=${BaseTimeBudget.instance.timeSufficient}');

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
    });
  }
}
