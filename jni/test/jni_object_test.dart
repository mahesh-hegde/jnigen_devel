// Copyright (c) 2022, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';
import 'dart:ffi';
import 'dart:isolate';

import 'package:test/test.dart';

import 'package:jni/jni.dart';

void main() {
  // Don't forget to initialize JNI.
  if (!Platform.isAndroid) {
    try {
      Jni.spawn(dylibDir: "build/jni_libs", jvmOptions: ["-Xmx128m"]);
    } on JvmExistsException catch (_) {
      // TODO(#51): Support destroying and reinstantiating JVM.
    }
  }

  // The API based on JniEnv is intended to closely mimic C API of JNI,
  // And thus can be too verbose for simple experimenting and one-off uses
  // JniObject API provides an easier way to perform some common operations.
  //
  // However, if binding generation using jnigen is possible, that should be
  // the first choice.
  test("Long.intValue() using JniObject", () {
    // JniClass wraps a local class reference, and
    // provides convenience functions.
    final longClass = Jni.findJniClass("java/lang/Long");

    // looks for a constructor with given signature.
    // equivalently you can lookup a method with name <init>
    final longCtor = longClass.getCtorID("(J)V");

    // note that the arguments are just passed as a list.
    // allowed argument types are primitive types, JniObject and its subclasses,
    // and raw JNI references (JObject). Strings will be automatically converted
    // to JNI strings.
    final long = longClass.newInstance(longCtor, [176]);

    final intValue = long.callMethodByName<int>("intValue", "()I", []);
    expect(intValue, equals(176));

    // delete any JniObject and JniClass instances using .delete() after use.
    // Deletion is not strictly required since JNI objects / classes have
    // a NativeFinalizer. But deleting them after use is a good practice.
    long.delete();
    longClass.delete();
  });

  test("call a static method using JniClass APIs", () {
    final integerClass = Jni.findJniClass("java/lang/Integer");
    final result = integerClass.callStaticMethodByName<JniString>(
        "toHexString", "(I)Ljava/lang/String;", [31]);

    // if the object is supposed to be a Java string
    // you can call toDartString on it.
    final resultString = result.toDartString();

    // Dart string is a copy, original object can be deleted.
    result.delete();
    expect(resultString, equals("1f"));

    // Also don't forget to delete the class
    integerClass.delete();
  });

  test("Call method with null argument, expect exception", () {
    final integerClass = Jni.findJniClass("java/lang/Integer");
    expect(
        () => integerClass.callStaticMethodByName<int>(
            "parseInt", "(Ljava/lang/String;)I", [nullptr]),
        throwsException);
    integerClass.delete();
  });

  test("Try to find a non-exisiting class, expect exception", () {
    expect(() => Jni.findJniClass("java/lang/NotExists"), throwsException);
  });

  /// callMethodByName will be expensive if making same call many times
  /// Use getMethodID to get a method ID and use it in subsequent calls
  test("Example for using getMethodID", () {
    final longClass = Jni.findJniClass("java/lang/Long");
    final bitCountMethod = longClass.getStaticMethodID("bitCount", "(J)I");

    // Use newInstance if you want only one instance.
    // It finds the class, gets constructor ID and constructs an instance.
    final random = Jni.newInstance("java/util/Random", "()V", []);

    // You don't need a JniClass reference to get instance method IDs
    final nextIntMethod = random.getMethodID("nextInt", "(I)I");

    for (int i = 0; i < 100; i++) {
      int r = random.callMethod<int>(nextIntMethod, [256 * 256]);
      int bits = 0;
      final jbc =
          longClass.callStaticMethod<int>(bitCountMethod, [JValueLong(r)]);
      while (r != 0) {
        bits += r % 2;
        r = (r / 2).floor();
      }
      expect(jbc, equals(bits));
    }
    Jni.deleteAll([random, longClass]);
  });

  // One-off invocation of static method in single call.
  test("invoke_", () {
    final m = Jni.invokeStaticMethod<int>("java/lang/Short", "compare", "(SS)I",
        [JValueShort(1234), JValueShort(1324)]);
    expect(m, equals(1234 - 1324));
  });

  test("Java char from string", () {
    final m = Jni.invokeStaticMethod<bool>("java/lang/Character", "isLowerCase",
        "(C)Z", [JValueChar.fromString('X')]);
    expect(m, isFalse);
  });

  // One-off access of static field in single call.
  test("Get static field directly", () {
    final maxLong = Jni.retrieveStaticField<int>(
        "java/lang/Short", "MAX_VALUE", "S", JniType.shortType);
    expect(maxLong, equals(32767));
  });

  // Use callStringMethod if all you care about is a string result
  test("callStaticStringMethod", () {
    final longClass = Jni.findJniClass("java/lang/Long");
    const n = 1223334444;
    final strFromJava = longClass.callStaticMethodByName<String>(
        "toOctalString", "(J)Ljava/lang/String;", [JValueLong(n)]);
    expect(strFromJava, equals(n.toRadixString(8)));
    longClass.delete();
  });

  // In JniObject, JniClass, and retrieve_/invoke_ methods
  // you can also pass Dart strings, apart from range of types
  // allowed by Jni.jvalues
  // They will be converted automatically.
  test(
    "Passing strings in arguments",
    () {
      final out = Jni.retrieveStaticField<JniObject>(
          "java/lang/System", "out", "Ljava/io/PrintStream;");
      // uncomment next line to see output
      // (\n because test runner prints first char at end of the line)
      //out.callMethodByName<Null>(
      //    "println", "(Ljava/lang/Object;)V", ["\nWorks (Apparently)"]);
      out.delete();
    },
  );

  test("Passing strings in arguments 2", () {
    final twelve = Jni.invokeStaticMethod<int>("java/lang/Byte", "parseByte",
        "(Ljava/lang/String;)B", ["12"], JniType.byteType);
    expect(twelve, equals(12));
  });

  // You can use() method on JniObject for using once and deleting.
  test("use() method", () {
    final randomInt = Jni.newInstance("java/util/Random", "()V", [])
        .use((random) => random.callMethodByName<int>("nextInt", "(I)I", [15]));
    expect(randomInt, lessThan(15));
  });

  // The JniObject and JniClass have NativeFinalizer. However, it's possible to
  // explicitly use `Arena`.
  test('Using arena', () {
    final objects = <JniObject>[];
    using((arena) {
      final r = Jni.findJniClass('java/util/Random')..deletedIn(arena);
      final ctor = r.getCtorID("()V");
      for (int i = 0; i < 10; i++) {
        objects.add(r.newInstance(ctor, [])..deletedIn(arena));
      }
    });
    for (var object in objects) {
      expect(object.isDeleted, isTrue);
    }
  });

  test("enums", () {
    // Don't forget to escape $ in nested type names
    final ordinal = Jni.retrieveStaticField<JniObject>(
            "java/net/Proxy\$Type", "HTTP", "Ljava/net/Proxy\$Type;")
        .use((f) => f.callMethodByName<int>("ordinal", "()I", []));
    expect(ordinal, equals(1));
  });

  test("Isolate", () {
    Isolate.spawn(doSomeWorkInIsolate, null);
  });
}

void doSomeWorkInIsolate(Void? _) {
  // On standalone target, make sure to call [setDylibDir] before accessing
  // any JNI function.
  //
  // otherwise getInstance will throw a "library not found" exception.
  Jni.setDylibDir(dylibDir: "build/jni_libs");
  final random = Jni.newInstance("java/util/Random", "()V", []);
  // final r = random.callMethodByName<int>("nextInt", "(I)I", [256]);
  // expect(r, lessThan(256));
  // Expect throws an [OutsideTestException]
  // but you can uncomment below print and see it works
  // print("\n$r");
  random.delete();
}
