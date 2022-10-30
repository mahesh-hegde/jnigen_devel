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

  Future<void> _getInteger() async {
    String displayResult = '';
    try {
      final int? integer = await methodChannel.invokeMethod('getInteger');
      displayResult += 'Received: $integer\n';
      final String? z10 =
          await methodChannel.invokeMethod('getStringOfLength', 10);
      displayResult += 'Received: $z10\n';
      final String? scream =
          await methodChannel.invokeMethod('toUpperCase', "scream");
      displayResult += 'Received: $scream\n';
      final int? maxNum = await methodChannel.invokeMethod(
          'max', Int32List.fromList([1, 27, 64, 3, 128, 256, 5, 6]));
      displayResult += 'Received: $maxNum\n';
    } on PlatformException catch (e) {
      displayResult = 'Error: $e';
    }
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
                  onPressed: _getInteger,
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
