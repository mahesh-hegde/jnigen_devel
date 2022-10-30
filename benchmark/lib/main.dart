// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:jni/jni.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'benchmark_functions.dart';

class BenchmarkApp extends StatefulWidget {
  const BenchmarkApp({super.key});

  @override
  State<BenchmarkApp> createState() => _BenchmarkAppState();
}

class _BenchmarkAppState extends State<BenchmarkApp> {
  static const MethodChannel methodChannel =
      MethodChannel('com.github.dart_lang.jnigen/benchmark');

  String _result = 'Unknown';

  num timeChannelMethod(String methodName, dynamic arguments, int nTimes) {
    final begin = DateTime.now();
    for (int i = 0; i < nTimes; i++) {
      Object? _ = methodChannel.invokeMethod(methodName, arguments);
    }
    final end = DateTime.now();
    return end.difference(begin).inMicroseconds / nTimes;
  }

  num timeFunction(Function() f, int nTimes) {
    final begin = DateTime.now();
    for (int i = 0; i < nTimes; i++) {
      f();
    }
    final end = DateTime.now();
    return end.difference(begin).inMicroseconds / nTimes;
  }

  int getInteger() {
    return MainActivity.getInteger();
  }

  String getStringOfLength(int n) {
    return MainActivity.getStringOfLength(n).toDartString(deleteOriginal: true);
  }

  String toUpperCase(String text) => using((arena) {
        return MainActivity.toUpperCase(text.jniString()..deletedIn(arena))
            .toDartString(deleteOriginal: true);
      });

  Future<void> _getResults() async {
    const n = 50;
    var result = 'Method channels:\n'
        'getInteger: ${timeChannelMethod("getInteger", null, 1000)}\n'
        'getStringOfLength($n): ${timeChannelMethod("getStringOfLength", n, 1000)}\n'
        'toUpperCase("s" * $n): ${timeChannelMethod("toUpperCase", "s" * n, 1000)}\n\n';

    result += 'JNI:\n'
        'getInteger: ${timeFunction(getInteger, 1000)}\n'
        'getStringOfLength($n): ${timeFunction(() => getStringOfLength(n), 1000)}\n'
        'toUpperCase("s" * $n): ${timeFunction(() => toUpperCase("s" * n), 1000)}\n';
    setState(() {
      _result = result + getStringOfLength(10);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(_result, key: const Key('Integer result label')),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: _getResults,
                  child: const Text('Refresh'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: BenchmarkApp()));
}
