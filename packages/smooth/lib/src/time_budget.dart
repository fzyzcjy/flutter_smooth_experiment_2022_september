abstract class BaseTimeBudget {
  static BaseTimeBudget instance = RealTimeBudget();

  bool get timeSufficient;
}

class RealTimeBudget extends BaseTimeBudget {
  // TODO implement it
  @override
  bool get timeSufficient => throw UnimplementedError();
}

class FakeTimeBudget extends BaseTimeBudget {
  final int initialRemainTime;

  FakeTimeBudget({required this.initialRemainTime}) : remainTime = initialRemainTime;
 
  void reset() => remainTime = initialRemainTime;

  int remainTime;

  @override
  bool get timeSufficient => remainTime > 0;
}
