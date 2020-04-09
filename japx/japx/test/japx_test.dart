import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import '../lib/src/parser.dart';
import 'test_data.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Basic decoding', () async {
    Map<String, dynamic> sample = await decodingSample1();
    Map<String, dynamic> result = await resultDecoding1();

    final decodedString = japxDecode(sample);
    expect(decodedString, result);
  });

  test('Advanced decoding', () async {
    Map<String, dynamic> sample = await decodingSample2();
    Map<String, dynamic> result = await resultDecoding2();

    final decodedString = japxDecode(sample);
    expect(decodedString, result);
  });

  test('Additional decoding', () async {
    Map<String, dynamic> sample = await decodingSample3();
    Map<String, dynamic> result = await resultDecoding3();

    final decodedString = japxDecode(sample);
    expect(decodedString, result);
  });

//  test('List decoding', () async {
//    Map<String, dynamic> sample = await decodingSample4();
//    Map<String, dynamic> result = await resultDecoding4();
//
//    final decodedString = japxDecode(sample);
//
//    expect(decodedString, result);
//  });

//  test('Error decoding', () async {
//    Map<String, dynamic> sample = await decodingSample5();
//    Map<String, dynamic> result = await resultDecoding4();
//
//    final decodedString = japxDecode(sample);
//
//    expect(decodedString, result);
//  });

  test('Basic encoding', () async => compare(japxEncode(await encodingSample1()), await resultEncoding1()));
  test('Extra params encoding', () async => compare(japxEncode(await encodingSample2()), await resultEncoding2()));

  test('Meta encoding', () async => compare(japxEncode(await encodingSample3()), await resultEncoding3()));
  test('Recursive encoding', () async => compare(japxEncode(await encodingSample4()), await resultEncoding4()));

  test('Simple encoding', () async => compare(japxEncode(await encodingSample5()), await resultEncoding5()));
}

void compare(Map<String, dynamic> sample, Map<String, dynamic> result) {
  print(jsonEncode(sample).toString());
  expect(sample, result);
}
