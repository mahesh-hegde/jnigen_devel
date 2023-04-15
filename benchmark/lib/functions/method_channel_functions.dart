// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:benchmark/functions/measured_functions.dart';
import 'package:flutter/services.dart';

class MethodChannelFunctions extends MeasuredFunctions {
  static const MethodChannel methodChannel =
      MethodChannel('com.github.dart_lang.jnigen/benchmark');

  @override
  String get implementationName => 'Method channel';

  @override
  Future<int> getInteger() async {
    return await methodChannel.invokeMethod('getInteger', null);
  }

  @override
  Future<String> getStringOfLength(int n) async {
    return await methodChannel.invokeMethod('getStringOfLength', n);
  }

  @override
  Future<String> toUpperCase(String s) async {
    return await methodChannel.invokeMethod('toUpperCase', s);
  }

  @override
  Future<int> max(
      int a, int b, int c, int d, int e, int f, int g, int h) async {
    return await methodChannel.invokeMethod('max', [a, b, c, d, e, f, g, h]);
  }
}
