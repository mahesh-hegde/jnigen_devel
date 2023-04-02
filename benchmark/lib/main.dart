// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:jni/jni.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'bindings/dart_only_bindings.dart';

const repetitions = 1000;

/// Runs a measurement and returns duration taken.
typedef Measurer = Future<Duration> Function(
    Map<String, int> variables, int repetitions);

class MeasurementCard extends StatefulWidget {
  static Map<String, TextEditingController> _getControllers(
          Map<String, int> tunables) =>
      tunables.map((name, defaultValue) =>
          MapEntry(name, TextEditingController(text: '$defaultValue')));

  MeasurementCard({
    required this.name,
    required this.measurers,
    required Map<String, int> tunables,
    Key? key,
  })  : controllers = _getControllers(tunables),
        super(key: key);
  final String name;
  final Map<String, Measurer> measurers;
  final Map<String, TextEditingController> controllers;

  @override
  State<StatefulWidget> createState() => _MeasurementCardState();
}

class _MeasurementCardState extends State<MeasurementCard> {
  Map<String, Future<Duration>> measurements = {};
  Map<String, int> _getTunables() => widget.controllers.map(
        (name, controller) => MapEntry(name, int.parse(controller.text)),
      );
  Map<String, Future<Duration>> _getMeasurements() => widget.measurers.map(
        (name, measurer) =>
            MapEntry(name, measurer(_getTunables(), repetitions)),
      );

  String _formatDuration(Duration duration) {
    final micros = duration.inMicroseconds;
    return '${micros / 1000} ms';
  }

  Widget _pad(Widget w) => Padding(padding: const EdgeInsets.all(8), child: w);

  @override
  Widget build(BuildContext context) {
    final controllers = widget.controllers;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.name,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              for (var tunable in controllers.keys)
                _pad(TextField(
                    decoration: InputDecoration(hintText: tunable),
                    controller: controllers[tunable]!)),
              for (var measurer in measurements.keys)
                _pad(
                  FutureBuilder(
                    future: measurements[measurer]!,
                    builder: (BuildContext context,
                            AsyncSnapshot<Duration> snapshot) =>
                        Text(
                      '$measurer: ${snapshot.hasData ? _formatDuration(snapshot.data!) : "waiting"}',
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ElevatedButton(
                child: const Text("Refresh"),
                onPressed: () {
                  setState(() => measurements = _getMeasurements());
                },
              ),
            ]),
      ),
    );
  }
}

class BenchmarkApp extends StatefulWidget {
  const BenchmarkApp({super.key});

  @override
  State<BenchmarkApp> createState() => _BenchmarkAppState();
}

class _BenchmarkAppState extends State<BenchmarkApp> {
  final input = TextEditingController(text: '50');
  static const MethodChannel methodChannel =
      MethodChannel('com.github.dart_lang.jnigen/benchmark');

  Future<Duration> timeChannelMethod(
      String methodName, dynamic arguments, int nTimes) async {
    final begin = DateTime.now();
    for (int i = 0; i < nTimes; i++) {
      Object? _ = await methodChannel.invokeMethod(methodName, arguments);
    }
    final end = DateTime.now();
    return end.difference(begin);
  }

  Future<Duration> timeFunction(Function() function, int nTimes) async {
    final begin = DateTime.now();
    for (int i = 0; i < nTimes; i++) {
      function();
    }
    final end = DateTime.now();
    return end.difference(begin);
  }

  int getInteger() {
    return MainActivity.getInteger();
  }

  String getStringOfLength(int n) {
    return MainActivity.getStringOfLength(n).toDartString(deleteOriginal: true);
  }

  String toUpperCase(String text) => using((arena) {
        return MainActivity.toUpperCase(text.toJString()..deletedIn(arena))
            .toDartString(deleteOriginal: true);
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "jnigen performance measurements",
      color: Colors.teal,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("JNI measurements"),
        ),
        body: ListView(
          children: <Widget>[
            MeasurementCard(
              name: "getInteger",
              measurers: {
                'Method channel': (_, reps) =>
                    timeChannelMethod('getInteger', null, reps),
                'JNI': (_, reps) => timeFunction(getInteger, reps),
              },
              tunables: const {},
            ),
            MeasurementCard(
              name: "getStringOfLength",
              tunables: const {"length": 50},
              measurers: {
                'Method channel': (params, reps) => timeChannelMethod(
                    'getStringOfLength', params["length"], reps),
                'JNI': (params, reps) {
                  final length = params["length"]!;
                  return timeFunction(() => getStringOfLength(length), reps);
                },
              },
            ),
            MeasurementCard(
              name: 'toUpperCase',
              tunables: const {"length": 50},
              measurers: {
                'Method channel': (params, reps) => timeChannelMethod(
                    'toUpperCase', "s" * params["length"]!, reps),
                'JNI': (params, reps) {
                  final arg = "e" * params["length"]!;
                  return timeFunction(() => toUpperCase(arg), reps);
                }
              },
            ),
            MeasurementCard(
              name: 'getOrigin',
              tunables: const {},
              measurers: {
                'JNI': (_, reps) => timeFunction(() {
                      final origin = MainActivity.getOrigin();
                      origin.delete();
                    }, reps),
              },
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: BenchmarkApp()));
}
