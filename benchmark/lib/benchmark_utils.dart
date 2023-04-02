// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:benchmark/functions/measured_functions.dart';

typedef SyncCallback = void Function();
typedef AsyncCallback<T> = Future<T> Function();

class Benchmarker {
  int repetitions;
  Benchmarker({required this.repetitions});

  Duration timeSyncCallback(SyncCallback callback) {
    final begin = DateTime.now();
    for (int i = 0; i < repetitions; i++) {
      callback();
    }
    final end = DateTime.now();
    return end.difference(begin);
  }

  Future<Duration> timeAsyncCallback<T>(AsyncCallback<T> callback) async {
    final begin = DateTime.now();
    for (int i = 0; i < repetitions; i++) {
      await callback();
    }
    final end = DateTime.now();
    return end.difference(begin);
  }

  static const stringLengths = [0, 1, 10, 50, 100, 250, 500];

  MeasurementResult measureSyncFunctions(SyncMeasuredFunctions functions) {
    final getStringTimes = <int, Duration>{};
    final toUpperCaseTimes = <int, Duration>{};
    final getIntegerTime = timeSyncCallback(functions.getInteger);
    for (final len in stringLengths) {
      getStringTimes[len] =
          timeSyncCallback(() => functions.getStringOfLength(len));
      final str = 's' * len;
      toUpperCaseTimes[len] =
          timeSyncCallback(() => functions.toUpperCase(str));
    }
    final maxFunctionTime =
        timeSyncCallback(() => functions.max(2, 4, 6, 8, 1, 3, 5, 7));
    return MeasurementResult(
      implementationName: functions.implementationName,
      integerGetTime: getIntegerTime,
      maxFunctionTime: maxFunctionTime,
      stringGetTimes: getStringTimes,
      toUpperCaseTimes: toUpperCaseTimes,
    );
  }

  Future<MeasurementResult> measureAsyncFunctions(
      AsyncMeasuredFunctions functions) async {
    final getStringTimes = <int, Duration>{};
    final toUpperCaseTimes = <int, Duration>{};
    final getIntegerTime = timeSyncCallback(functions.getInteger);
    for (final len in stringLengths) {
      getStringTimes[len] =
          await timeAsyncCallback(() => functions.getStringOfLength(len));
      final str = 's' * len;
      toUpperCaseTimes[len] =
          await timeAsyncCallback(() => functions.toUpperCase(str));
    }
    final maxFunctionTime =
        timeSyncCallback(() => functions.max(2, 4, 6, 8, 1, 3, 5, 7));
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
