void main() {
  final binding = SmoothIntegrationTestWidgetsFlutterBinding.ensureInitialized();

  for (final enableSmooth in [false, true]) {
    testWidgets('enableSmooth=$enableSmooth', (tester) async {
      await tester.pumpWidget(_ExampleApp(enableSmooth: enableSmooth));

      await binding.traceAction(reportKey: enableSmooth ? 'smooth_enable' : 'smooth_disable', () async {
        TODO;
        await tester.pumpAndSettle();
      });

      TODO;
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
