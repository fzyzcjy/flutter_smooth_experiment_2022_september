import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smooth/smooth.dart';
import 'package:smooth/src/time_budget.dart';

import 'test_utils.dart';

void main() {
  const initialRemainTime = 3;
  setUp(() => BaseTimeBudget.debugOverrideInstance = FakeTimeBudget(initialRemainTime: initialRemainTime));
  tearDown(() => BaseTimeBudget.debugOverrideInstance = null);

  for (final heavyPart in _HeavyPart.values) {
    group('heavyPart=$heavyPart', () {
      testWidgets('when too heavy in total, several widgets should be in current frame, and the rest should be later',
          (tester) async {
        FakeTimeBudget.instance.reset();
        final builtWidgets = <int>{};

        await tester.pumpWidget(Column(
          children: [
            for (var i = 0; i < 5; ++i)
              Smooth(
                child: heavyPart.buildWidget(
                  child: SpyStatefulWidget(
                    onBuild: () => builtWidgets.add(i),
                  ),
                ),
              ),
          ],
        ));

        expect(builtWidgets, {0, 1, 2});

        FakeTimeBudget.instance.reset();
        await tester.pump();
        expect(builtWidgets, {0, 1, 2, 3, 4});

        FakeTimeBudget.instance.reset();
        await tester.pump();
        expect(builtWidgets, {0, 1, 2, 3, 4});
      });
    });
  }
}

enum _HeavyPart {
  layout,
  build,
  initState;

  Widget buildWidget({Widget? child}) {
    switch (this) {
      case _HeavyPart.layout:
        return _HeavyLayoutWidget(child: child);
      case _HeavyPart.build:
        return _HeavyBuildWidget(child: child);
      case _HeavyPart.initState:
        return _HeavyInitStateWidget(child: child);
    }
  }
}

class _HeavyLayoutWidget extends StatelessWidget {
  final Widget? child;

  const _HeavyLayoutWidget({this.child});

  @override
  Widget build(BuildContext context) {
    return SpyRenderObjectWidget(
      onPerformLayout: () => FakeTimeBudget.instance.remainTime--,
      child: child,
    );
  }
}

class _HeavyBuildWidget extends StatelessWidget {
  final Widget? child;

  const _HeavyBuildWidget({this.child});

  @override
  Widget build(BuildContext context) {
    return SpyStatefulWidget(
      onBuild: () => FakeTimeBudget.instance.remainTime--,
      child: child,
    );
  }
}

class _HeavyInitStateWidget extends StatelessWidget {
  final Widget? child;

  const _HeavyInitStateWidget({this.child});

  @override
  Widget build(BuildContext context) {
    return SpyStatefulWidget(
      onInitState: () => FakeTimeBudget.instance.remainTime--,
      child: child,
    );
  }
}
