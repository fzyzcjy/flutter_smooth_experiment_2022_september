import 'package:example/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:smooth/smooth.dart';
import 'package:smooth/src/scheduler_binding.dart';

void main() {
  final binding = SmoothIntegrationTestWidgetsFlutterBinding.ensureInitialized();

  for (final enableSmooth in [false, true]) {
    testWidgets('enableSmooth=$enableSmooth', (tester) async {
      await tester.pumpWidget(MaterialApp(home: ExamplePage(enableSmooth: enableSmooth)));

      final timeline = await binding.traceTimeline(() async {
        await tester.scrollUntilVisible(
          find.byKey(const ValueKey('item-200')),
          200,
          duration: const Duration(milliseconds: 50),
          maxScrolls: 1000,
        );
      });

      final reportKey = enableSmooth ? 'smooth_enable' : 'smooth_disable';
      // ignore: avoid_dynamic_calls
      ((binding.reportData ??= <String, dynamic>{})['benchmark_reports'] ??= <String, dynamic>{})[reportKey] =
          timeline.toJson();
    });
  }
}

// TODO make it a package
class SmoothIntegrationTestWidgetsFlutterBinding extends IntegrationTestWidgetsFlutterBinding
    with SmoothSchedulerBindingMixin {
  @override
  void initInstances() {
    super.initInstances();
    _instance = this;
  }

  static SmoothIntegrationTestWidgetsFlutterBinding get instance => BindingBase.checkInstance(_instance);
  static SmoothIntegrationTestWidgetsFlutterBinding? _instance;

  // ignore: prefer_constructors_over_static_methods
  static SmoothIntegrationTestWidgetsFlutterBinding ensureInitialized() {
    if (SmoothIntegrationTestWidgetsFlutterBinding._instance == null) SmoothIntegrationTestWidgetsFlutterBinding();
    return SmoothIntegrationTestWidgetsFlutterBinding.instance;
  }
}
