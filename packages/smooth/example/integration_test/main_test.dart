import 'package:example/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:smooth/smooth.dart';
import 'package:smooth/src/scheduler_binding.dart';

void main() {
  final binding = SmoothIntegrationTestWidgetsFlutterBinding.ensureInitialized();

  for (final enableSmooth in [false, true]) {
    testWidgets('enableSmooth=$enableSmooth', (tester) async {
      await tester.pumpWidget(ExamplePage(enableSmooth: enableSmooth));

      await binding.traceAction(reportKey: enableSmooth ? 'smooth_enable' : 'smooth_disable', () async {
        await tester.scrollUntilVisible(find.byKey(const ValueKey('item-50')), 200);
      });
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
