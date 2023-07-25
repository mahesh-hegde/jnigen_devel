// Copyright (c) 2023, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:jnigen/src/bindings/descriptor.dart';
import 'package:jnigen/src/bindings/linker.dart';
import 'package:jnigen/src/bindings/unnester.dart';
import 'package:jnigen/src/config/config_types.dart';
import 'package:jnigen/src/summary/summary.dart';
import 'package:test/test.dart';

import 'simple_package_test/generate.dart' as simple_package_test;
import 'kotlin_test/generate.dart' as kotlin_test;
import 'jackson_core_test/generate.dart' as jackson_core_test;
import 'test_util/test_util.dart';

void main() {
  checkLocallyBuiltDependencies();
  test('Method descriptor generation', timeout: const Timeout.factor(3),
      () async {
    final configGetters = [
      simple_package_test.getConfig,
      kotlin_test.getConfig,
      jackson_core_test.getConfig
    ];
    for (final getConfig in configGetters) {
      final config = getConfig();
      config.summarizerOptions =
          SummarizerOptions(backend: SummarizerBackend.asm);
      final classes = await getSummary(config);
      await classes.accept(Linker(config));
      classes.accept(const Unnester());
      for (final decl in classes.decls.values) {
        // Checking if the descriptor from ASM matches the one generated by
        // [MethodDescriptor].
        final methodDescriptor = MethodDescriptor(decl.allTypeParams);
        for (final method in decl.methods) {
          expect(method.descriptor, method.accept(methodDescriptor));
        }
      }
    }
  });
}
