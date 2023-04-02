// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

abstract class MeasuredFunctions {
  String get implementationName;
}

abstract class SyncMeasuredFunctions extends MeasuredFunctions {
  int getInteger();
  int max(int a, int b, int c, int d, int e, int f, int g, int h);
  String getStringOfLength(int n);
  String toUpperCase(String s);
}

abstract class AsyncMeasuredFunctions extends MeasuredFunctions {
  Future<int> getInteger();
  Future<int> max(int a, int b, int c, int d, int e, int f, int g, int h);
  Future<String> getStringOfLength(int n);
  Future<String> toUpperCase(String s);
}

class MeasurementResult {
  String implementationName;
  Duration integerGetTime;
  Duration maxFunctionTime;
  Map<int, Duration> stringGetTimes;
  Map<int, Duration> toUpperCaseTimes;

  MeasurementResult({
    required this.implementationName,
    required this.integerGetTime,
    required this.maxFunctionTime,
    required this.stringGetTimes,
    required this.toUpperCaseTimes,
  });
}
