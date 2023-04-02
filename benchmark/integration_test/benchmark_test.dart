import 'dart:io';

import 'package:benchmark/benchmark_utils.dart';
import 'package:benchmark/functions/c_based_functions.dart';
import 'package:benchmark/functions/dart_only_functions.dart';
import 'package:benchmark/functions/method_channel_functions.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:benchmark/main.dart' as app;

extension PadStringIterable on Iterable<String> {
  Iterable<String> pad(int padding) => map((s) => s.padRight(padding));
}

String _formatDuration(Duration duration) {
  final millis = (duration.inMicroseconds / 1000.0);
  return '$millis ms';
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Benchmark:', () {
    testWidgets('Benchmark different interop implementations', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      final benchmarker = Benchmarker(repetitions: 1000);
      final benchmarkNames = benchmarker
          .getBenchmarkNames()
          .map((name) => name.padRight(28))
          .toList();
      final columns = <List<String>>[benchmarkNames];
      final columnNames = <String>['Name'];
      final syncMeasurables = [CBasedFunctions(), DartOnlyFunctions()];
      for (var m in syncMeasurables) {
        m.getInteger();
        columnNames.add(m.implementationName);
        final result = benchmarker.measureSyncFunctions(m);
        columns.add(benchmarker
            .getBenchmarkResults(result)
            .map(_formatDuration)
            .pad(28)
            .toList());
      }

      final asyncMeasurables = [MethodChannelFunctions()];
      for (var m in asyncMeasurables) {
        await m.getInteger();
        columnNames.add(m.implementationName);
        final result = await benchmarker.measureAsyncFunctions(m);
        columns.add(benchmarker
            .getBenchmarkResults(result)
            .map(_formatDuration)
            .pad(28)
            .toList());
      }

      // Print results
      debugPrint(columnNames.pad(28).join("| "));
      for (int i = 0; i < benchmarkNames.length; i++) {
        final line = columns.map((col) => col[i]).join("| ");
        debugPrint(line);
      }
    });
  });
}
