import 'package:smooth/src/scheduler_binding.dart';

abstract class BaseTimeBudget {
  static BaseTimeBudget get instance => debugOverrideInstance ?? _realInstance;

  static BaseTimeBudget? debugOverrideInstance;

  static final _realInstance = RealTimeBudget();

  bool get timeSufficient;
}

class RealTimeBudget extends BaseTimeBudget {
  // TODO make it configurable
  static const kTimeThreshold = Duration(milliseconds: 12);

  @override
  bool get timeSufficient =>
      DateTime.now().difference(SmoothWidgetsFlutterBinding.instance.beginFrameTime!) < kTimeThreshold;
}

class FakeTimeBudget extends BaseTimeBudget {
  static FakeTimeBudget get instance => BaseTimeBudget.instance as FakeTimeBudget;

  final int initialRemainTime;

  FakeTimeBudget({required this.initialRemainTime}) : remainTime = initialRemainTime;

  void reset() => remainTime = initialRemainTime;

  int remainTime;

  @override
  bool get timeSufficient => remainTime > 0;
}
