// Copyright (c) 2022, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Autogenerated by jnigen. DO NOT EDIT!

// ignore_for_file: annotate_overrides
// ignore_for_file: camel_case_types
// ignore_for_file: constant_identifier_names
// ignore_for_file: file_names
// ignore_for_file: no_leading_underscores_for_local_identifiers
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: unused_element
// ignore_for_file: unused_import

import "dart:ffi" as ffi;
import "package:jni/internal_helpers_for_jnigen.dart";
import "package:jni/jni.dart" as jni;

// Auto-generated initialization code.

final ffi.Pointer<T> Function<T extends ffi.NativeType>(String sym) jniLookup =
    ProtectedJniExtensions.initGeneratedLibrary("simple_package");

/// from: com.github.dart_lang.jnigen.simple_package.Example
class Example extends jni.JniObject {
  Example.fromRef(ffi.Pointer<ffi.Void> ref) : super.fromRef(ref);

  /// from: static public final int ON
  static const ON = 1;

  /// from: static public final int OFF
  static const OFF = 0;

  static final _get_aux =
      jniLookup<ffi.NativeFunction<jni.JniResult Function()>>(
              "get_Example__aux")
          .asFunction<jni.JniResult Function()>();

  /// from: static public com.github.dart_lang.jnigen.simple_package.Example.Aux aux
  /// The returned object must be deleted after use, by calling the `delete` method.
  static Example_Aux get aux => Example_Aux.fromRef(_get_aux().object);
  static final _set_aux = jniLookup<
          ffi.NativeFunction<
              jni.JThrowable Function(
                  ffi.Pointer<ffi.Void>)>>("set_Example__aux")
      .asFunction<jni.JThrowable Function(ffi.Pointer<ffi.Void>)>();

  /// from: static public com.github.dart_lang.jnigen.simple_package.Example.Aux aux
  /// The returned object must be deleted after use, by calling the `delete` method.
  static set aux(Example_Aux value) => _set_aux(value.reference);

  static final _get_num =
      jniLookup<ffi.NativeFunction<jni.JniResult Function()>>(
              "get_Example__num")
          .asFunction<jni.JniResult Function()>();

  /// from: static public int num
  static int get num => _get_num().integer;
  static final _set_num =
      jniLookup<ffi.NativeFunction<jni.JThrowable Function(ffi.Int32)>>(
              "set_Example__num")
          .asFunction<jni.JThrowable Function(int)>();

  /// from: static public int num
  static set num(int value) => _set_num(value);

  static final _ctor =
      jniLookup<ffi.NativeFunction<jni.JniResult Function()>>("Example__ctor")
          .asFunction<jni.JniResult Function()>();

  /// from: public void <init>()
  Example() : super.fromRef(_ctor().object);

  static final _whichExample = jniLookup<
          ffi.NativeFunction<
              jni.JniResult Function(
                  ffi.Pointer<ffi.Void>)>>("Example__whichExample")
      .asFunction<jni.JniResult Function(ffi.Pointer<ffi.Void>)>();

  /// from: public int whichExample()
  int whichExample() => _whichExample(reference).integer;

  static final _getAux =
      jniLookup<ffi.NativeFunction<jni.JniResult Function()>>("Example__getAux")
          .asFunction<jni.JniResult Function()>();

  /// from: static public com.github.dart_lang.jnigen.simple_package.Example.Aux getAux()
  /// The returned object must be deleted after use, by calling the `delete` method.
  static Example_Aux getAux() => Example_Aux.fromRef(_getAux().object);

  static final _addInts = jniLookup<
              ffi.NativeFunction<jni.JniResult Function(ffi.Int32, ffi.Int32)>>(
          "Example__addInts")
      .asFunction<jni.JniResult Function(int, int)>();

  /// from: static public int addInts(int a, int b)
  static int addInts(int a, int b) => _addInts(a, b).integer;

  static final _getArr =
      jniLookup<ffi.NativeFunction<jni.JniResult Function()>>("Example__getArr")
          .asFunction<jni.JniResult Function()>();

  /// from: static public java.lang.Integer[] getArr()
  /// The returned object must be deleted after use, by calling the `delete` method.
  static jni.JniObject getArr() => jni.JniObject.fromRef(_getArr().object);

  static final _addAll = jniLookup<
          ffi.NativeFunction<
              jni.JniResult Function(ffi.Pointer<ffi.Void>)>>("Example__addAll")
      .asFunction<jni.JniResult Function(ffi.Pointer<ffi.Void>)>();

  /// from: static public int addAll(java.lang.Integer[] arr)
  static int addAll(jni.JniObject arr) => _addAll(arr.reference).integer;

  static final _getSelf = jniLookup<
          ffi.NativeFunction<
              jni.JniResult Function(
                  ffi.Pointer<ffi.Void>)>>("Example__getSelf")
      .asFunction<jni.JniResult Function(ffi.Pointer<ffi.Void>)>();

  /// from: public com.github.dart_lang.jnigen.simple_package.Example getSelf()
  /// The returned object must be deleted after use, by calling the `delete` method.
  Example getSelf() => Example.fromRef(_getSelf(reference).object);

  static final _getNum = jniLookup<
          ffi.NativeFunction<
              jni.JniResult Function(ffi.Pointer<ffi.Void>)>>("Example__getNum")
      .asFunction<jni.JniResult Function(ffi.Pointer<ffi.Void>)>();

  /// from: public int getNum()
  int getNum() => _getNum(reference).integer;

  static final _setNum = jniLookup<
          ffi.NativeFunction<
              jni.JniResult Function(
                  ffi.Pointer<ffi.Void>, ffi.Int32)>>("Example__setNum")
      .asFunction<jni.JniResult Function(ffi.Pointer<ffi.Void>, int)>();

  /// from: public void setNum(int num)
  void setNum(int num) => _setNum(reference, num).check();

  static final _throwException =
      jniLookup<ffi.NativeFunction<jni.JniResult Function()>>(
              "Example__throwException")
          .asFunction<jni.JniResult Function()>();

  /// from: static public void throwException()
  static void throwException() => _throwException().check();
}

/// from: com.github.dart_lang.jnigen.simple_package.Example$Aux
class Example_Aux extends jni.JniObject {
  Example_Aux.fromRef(ffi.Pointer<ffi.Void> ref) : super.fromRef(ref);

  static final _get_value = jniLookup<
          ffi.NativeFunction<
              jni.JniResult Function(
    jni.JObject,
  )>>("get_Example_Aux__value")
      .asFunction<
          jni.JniResult Function(
    jni.JObject,
  )>();

  /// from: public boolean value
  bool get value => _get_value(reference).boolean;
  static final _set_value = jniLookup<
          ffi.NativeFunction<
              jni.JThrowable Function(
                  jni.JObject, ffi.Uint8)>>("set_Example_Aux__value")
      .asFunction<jni.JThrowable Function(jni.JObject, int)>();

  /// from: public boolean value
  set value(bool value) => _set_value(reference, value ? 1 : 0);

  static final _ctor =
      jniLookup<ffi.NativeFunction<jni.JniResult Function(ffi.Uint8)>>(
              "Example_Aux__ctor")
          .asFunction<jni.JniResult Function(int)>();

  /// from: public void <init>(boolean value)
  Example_Aux(bool value) : super.fromRef(_ctor(value ? 1 : 0).object);

  static final _getValue = jniLookup<
          ffi.NativeFunction<
              jni.JniResult Function(
                  ffi.Pointer<ffi.Void>)>>("Example_Aux__getValue")
      .asFunction<jni.JniResult Function(ffi.Pointer<ffi.Void>)>();

  /// from: public boolean getValue()
  bool getValue() => _getValue(reference).boolean;

  static final _setValue = jniLookup<
          ffi.NativeFunction<
              jni.JniResult Function(
                  ffi.Pointer<ffi.Void>, ffi.Uint8)>>("Example_Aux__setValue")
      .asFunction<jni.JniResult Function(ffi.Pointer<ffi.Void>, int)>();

  /// from: public void setValue(boolean value)
  void setValue(bool value) => _setValue(reference, value ? 1 : 0).check();
}

/// from: com.github.dart_lang.jnigen.pkg2.C2
class C2 extends jni.JniObject {
  C2.fromRef(ffi.Pointer<ffi.Void> ref) : super.fromRef(ref);

  static final _get_CONSTANT =
      jniLookup<ffi.NativeFunction<jni.JniResult Function()>>(
              "get_C2__CONSTANT")
          .asFunction<jni.JniResult Function()>();

  /// from: static public int CONSTANT
  static int get CONSTANT => _get_CONSTANT().integer;
  static final _set_CONSTANT =
      jniLookup<ffi.NativeFunction<jni.JThrowable Function(ffi.Int32)>>(
              "set_C2__CONSTANT")
          .asFunction<jni.JThrowable Function(int)>();

  /// from: static public int CONSTANT
  static set CONSTANT(int value) => _set_CONSTANT(value);

  static final _ctor =
      jniLookup<ffi.NativeFunction<jni.JniResult Function()>>("C2__ctor")
          .asFunction<jni.JniResult Function()>();

  /// from: public void <init>()
  C2() : super.fromRef(_ctor().object);
}

/// from: com.github.dart_lang.jnigen.pkg2.Example
class Example1 extends jni.JniObject {
  Example1.fromRef(ffi.Pointer<ffi.Void> ref) : super.fromRef(ref);

  static final _ctor =
      jniLookup<ffi.NativeFunction<jni.JniResult Function()>>("Example1__ctor")
          .asFunction<jni.JniResult Function()>();

  /// from: public void <init>()
  Example1() : super.fromRef(_ctor().object);

  static final _whichExample = jniLookup<
          ffi.NativeFunction<
              jni.JniResult Function(
                  ffi.Pointer<ffi.Void>)>>("Example1__whichExample")
      .asFunction<jni.JniResult Function(ffi.Pointer<ffi.Void>)>();

  /// from: public int whichExample()
  int whichExample() => _whichExample(reference).integer;
}
