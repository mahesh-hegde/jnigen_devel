// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:jni/jni.dart';

import 'package:benchmark/bindings/dart_only_bindings.dart';
import 'package:benchmark/functions/measured_functions.dart';

class DartOnlyFunctions implements SyncMeasuredFunctions {
  @override
  String get implementationName => "jnigen (pure dart)";

  @override
  int getInteger() => MainActivity.getInteger();

  @override
  String getStringOfLength(int n) =>
      MainActivity.getStringOfLength(n).toDartString(deleteOriginal: true);

  @override
  String toUpperCase(String s) => using((arena) {
        final js = JString.fromString(s)..deletedIn(arena);
        return MainActivity.toUpperCase(js).toDartString(deleteOriginal: true);
      });

  @override
  int max(int a, int b, int c, int d, int e, int f, int g, int h) {
    return MainActivity.max(a, b, c, d, e, f, g, h);
  }
}
