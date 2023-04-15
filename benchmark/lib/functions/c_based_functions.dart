// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:jni/jni.dart';

import 'package:benchmark/functions/measured_functions.dart';
import 'package:benchmark/bindings/c_based_bindings.dart';

class CBasedFunctions implements MeasuredFunctions {
  @override
  String get implementationName => "jnigen (C)";

  @override
  Future<int> getInteger() async => MainActivity.getInteger();

  @override
  Future<String> getStringOfLength(int n) async =>
      MainActivity.getStringOfLength(n).toDartString(deleteOriginal: true);

  @override
  Future<String> toUpperCase(String s) async => using((arena) {
        final js = JString.fromString(s)..deletedIn(arena);
        return MainActivity.toUpperCase(js).toDartString(deleteOriginal: true);
      });

  @override
  Future<int> max(
      int a, int b, int c, int d, int e, int f, int g, int h) async {
    return MainActivity.max(a, b, c, d, e, f, g, h);
  }
}
