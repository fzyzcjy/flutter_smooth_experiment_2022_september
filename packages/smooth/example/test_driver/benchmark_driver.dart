import 'package:flutter_driver/flutter_driver.dart' as driver;
import 'package:integration_test/integration_test_driver.dart';

Future<void> main() {
  return integrationDriver(
    responseDataCallback: (data) async {
      final reports = data!['benchmark_reports']! as Map<String, Object?>;
      for (final reportName in reports.keys) {
        final timeline = driver.Timeline.fromJson(reports[reportName]! as Map<String, Object?>);
        final summary = driver.TimelineSummary.summarize(timeline);
        await summary.writeTimelineToFile(reportName, pretty: true, includeSummary: true);
      }
    },
  );
}
