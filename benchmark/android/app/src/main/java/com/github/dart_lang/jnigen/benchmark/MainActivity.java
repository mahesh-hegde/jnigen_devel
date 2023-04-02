// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package com.github.dart_lang.jnigen.benchmark;

import androidx.annotation.Keep;
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

import java.util.Objects;
import java.util.ArrayList;

@Keep
public class MainActivity extends FlutterActivity {
  private static final String BENCHMARK_CHANNEL = "com.github.dart_lang.jnigen/benchmark";

  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    super.configureFlutterEngine(flutterEngine);
    new MethodChannel(flutterEngine.getDartExecutor(), BENCHMARK_CHANNEL)
        .setMethodCallHandler(
            (call, result) -> {
              switch (call.method) {
                case "getInteger":
                  result.success(getInteger());
                  break;
                case "getStringOfLength":
                  Integer n = Objects.requireNonNull(call.arguments());
                  result.success(getStringOfLength(n));
                  break;
                case "toUpperCase":
                  String text = Objects.requireNonNull(call.arguments());
                  result.success(toUpperCase(text));
                  break;
                case "max":
                  ArrayList<Integer> numbers = Objects.requireNonNull(call.arguments());
                  result.success(
                      max(
                          numbers.get(0),
                          numbers.get(1),
                          numbers.get(2),
                          numbers.get(3),
                          numbers.get(4),
                          numbers.get(5),
                          numbers.get(6),
                          numbers.get(7)));
                  break;
              }
            });
  }

  public static int getInteger() {
    return 72;
  }

  public static String getStringOfLength(int n) {
    StringBuilder buffer = new StringBuilder();
    for (int i = 0; i < n; i++) {
      buffer.append("z");
    }
    return buffer.toString();
  }

  @Keep
  public static class Coordinate {
    public int x, y, z;

    public Coordinate(int x, int y, int z) {
      this.x = x;
      this.y = y;
      this.z = z;
    }
  }

  @Keep
  public static Coordinate getOrigin() {
    return new Coordinate(0, 0, 0);
  }

  @Keep
  public static Coordinate getMidPoint(Coordinate a, Coordinate b) {
    return new Coordinate((a.x + b.x) / 2, (a.y + b.y) / 2, (a.z + b.z) / 2);
  }

  public static String toUpperCase(String text) {
    return text;
  }

  public static int max(int a, int b, int c, int d, int e, int f, int g, int h) {
    int abcd = Math.max(Math.max(a, b), Math.max(c, d));
    int efgh = Math.max(Math.max(e, f), Math.max(g, h));
    return Math.max(abcd, efgh);
  }
}