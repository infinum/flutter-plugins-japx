import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import '../lib/src/parser.dart';
import 'test_data.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Basic decoding 1', () async => compare(japxDecode(await decodingSample1()), await resultDecoding1()));
  test('Basic decoding2', () async => compare(japxDecode(await decodingSample2()), await resultDecoding2()));
  test('Basic decoding3', () async => compare(japxDecode(await decodingSample3()), await resultDecoding3()));
  test('Basic decoding4', () async => compare(japxDecode(await decodingSample4()), await resultDecoding4()));
  test('Basic decoding5', () async => compare(japxDecode(await decodingSample5()), await resultDecoding5()));
  test('Basic decoding6', () async => compare(japxDecode(await decodingSample6()), await resultDecoding6()));
  test('Basic decoding7', () async => compare(japxDecode(await decodingSample7()), await resultDecoding7()));

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
