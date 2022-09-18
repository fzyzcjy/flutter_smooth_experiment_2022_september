abstract class BaseTimeBudget {
  static BaseTimeBudget get instance => debugOverrideInstance ?? _realInstance;

  static BaseTimeBudget? debugOverrideInstance;

  static final _realInstance = RealTimeBudget();

  bool get timeSufficient;
}

class RealTimeBudget extends BaseTimeBudget {
  // TODO implement it
  @override
  bool get timeSufficient => throw UnimplementedError();
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
