// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:benchmark/functions/measured_functions.dart';

typedef SyncCallback = void Function();
typedef AsyncCallback<T> = Future<T> Function();

class Benchmarker {
  int repetitions;
  Benchmarker({required this.repetitions});

  Future<Duration> timeAsyncCallback<T>(AsyncCallback<T> callback) async {
    // call the callback once to remove any warmup effects.
    await callback();
    final stopwatch = Stopwatch()..start();
    for (int i = 0; i < repetitions; i++) {
      await callback();
    }
    stopwatch.stop();
    return Duration(microseconds: stopwatch.elapsedMicroseconds);
  }

  static const stringLengths = [1, 10, 50, 0, 100, 250, 500];

  Future<MeasurementResult> measureFunctions(
      MeasuredFunctions functions) async {
    final getStringTimes = <int, Duration>{};
    final toUpperCaseTimes = <int, Duration>{};
    for (final len in stringLengths) {
      getStringTimes[len] =
          await timeAsyncCallback(() => functions.getStringOfLength(len));
      final str = 's' * len;
      toUpperCaseTimes[len] =
          await timeAsyncCallback(() => functions.toUpperCase(str));
    }
    final getIntegerTime = await timeAsyncCallback(functions.getInteger);
    final maxFunctionTime =
        await timeAsyncCallback(() => functions.max(2, 4, 6, 8, 1, 3, 5, 7));
    return MeasurementResult(
      implementationName: functions.implementationName,
      integerGetTime: getIntegerTime,
      maxFunctionTime: maxFunctionTime,
      stringGetTimes: getStringTimes,
      toUpperCaseTimes: toUpperCaseTimes,
    );
  }

  List<String> getBenchmarkNames() {
    return <String>[
      "Get simple integer",
      for (var len in stringLengths) "Get string of len=$len",
      for (var len in stringLengths) "ToUpper string of len=$len",
      "Get max of 8 ints",
    ];
  }

  List<Duration> getBenchmarkResults(MeasurementResult result) {
    return [
      result.integerGetTime,
      ...result.stringGetTimes.values.toList(),
      ...result.toUpperCaseTimes.values.toList(),
      result.maxFunctionTime,
    ];
  }
}
