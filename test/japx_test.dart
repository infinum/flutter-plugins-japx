import 'package:flutter_test/flutter_test.dart';

import '../lib/src/parser.dart';
import 'test_data.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Basic decoding', () async => compare(japxDecode(await decodingSample1()), await resultDecoding1()));
  test('Relationship decoding', () async => compare(japxDecode(await decodingSample2()), await resultDecoding2()));
  test('Additional info decoding', () async => compare(japxDecode(await decodingSample3()), await resultDecoding3()));
  test(
      'Recursive decoding',
      () async =>
          compare(japxDecode(await decodingSample4(), includeList: 'author.article.author'), await resultDecoding4()));
  test(
      'Relationship no include decoding',
      () async =>
          compare(japxDecode(await decodingSample5(), includeList: 'author.article.author'), await resultDecoding5()));
  test(
      'Advanced decoding',
      () async =>
          compare(japxDecode(await decodingSample6(), includeList: 'author,comments.author'), await resultDecoding6()));
  test(
      'Empty relationship decoding',
      () async => compare(japxDecode(await decodingSample7(), includeList: 'author.categories,author.article.author'),
          await resultDecoding7()));

  test('Basic encoding', () async => compare(japxEncode(await encodingSample1()), await resultEncoding1()));
  test('Extra params encoding', () async => compare(japxEncode(await encodingSample2()), await resultEncoding2()));
  test('Meta encoding', () async => compare(japxEncode(await encodingSample3()), await resultEncoding3()));
  test('Recursive encoding', () async => compare(japxEncode(await encodingSample4()), await resultEncoding4()));
  test('Simple encoding', () async => compare(japxEncode(await encodingSample5()), await resultEncoding5()));
}

void compare(Map<String, dynamic> sample, Map<String, dynamic> result) => expect(sample, result);
