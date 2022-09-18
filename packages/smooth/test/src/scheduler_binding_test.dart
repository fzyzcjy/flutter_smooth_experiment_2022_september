import 'package:clock/clock.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smooth/src/scheduler_binding.dart';

void main() {
  SmoothAutomatedTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('should get beginFrameTime', (tester) async {
    final startTime = clock.now();

    await tester.pumpWidget(const CircularProgressIndicator(), const Duration(milliseconds: 100));
    expect(SmoothSchedulerBindingMixin.instance.beginFrameTime, startTime.add(const Duration(milliseconds: 100)));

    await tester.pump(const Duration(milliseconds: 200));
    expect(SmoothSchedulerBindingMixin.instance.beginFrameTime, startTime.add(const Duration(milliseconds: 300)));

    await tester.pump(const Duration(milliseconds: 300));
    expect(SmoothSchedulerBindingMixin.instance.beginFrameTime, startTime.add(const Duration(milliseconds: 600)));
  });
}

// TODO make it a package
class SmoothAutomatedTestWidgetsFlutterBinding extends AutomatedTestWidgetsFlutterBinding
    with SmoothSchedulerBindingMixin {
  @override
  void initInstances() {
    super.initInstances();
    _instance = this;
  }

  static SmoothAutomatedTestWidgetsFlutterBinding get instance => BindingBase.checkInstance(_instance);
  static SmoothAutomatedTestWidgetsFlutterBinding? _instance;

  // ignore: prefer_constructors_over_static_methods
  static SmoothAutomatedTestWidgetsFlutterBinding ensureInitialized() {
    if (SmoothAutomatedTestWidgetsFlutterBinding._instance == null) SmoothAutomatedTestWidgetsFlutterBinding();
    return SmoothAutomatedTestWidgetsFlutterBinding.instance;
  }
}
