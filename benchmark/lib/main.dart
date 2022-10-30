// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    return end.difference(begin).inMicroseconds / 1000;
  }

  Future<void> _getResults() async {
    var displayResult =
        'getInteger: ${timeChannelMethod("getInteger", null, 1000)}\n'
        'getStringOfLength(1000): ${timeChannelMethod("getStringOfLength", 1000, 1000)}\n'
        'toUpperCase(1000): ${timeChannelMethod("toUpperCase", "s" * 1000, 1000)}\n'
        'max: ${timeChannelMethod("max", Int32List.fromList([
                  1,
                  2,
                  3,
                  4,
                  5,
                  10,
                  5,
                  11
                ]), 1000)}\n';

    setState(() {
      _result = displayResult;
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
