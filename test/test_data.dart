import 'dart:convert';

import 'package:flutter/services.dart';

Future<Map<String, dynamic>> decodingSample1() async =>
    parseJsonFromAssets('packages/japx/assets/decoding/decoding-1.json');
Future<Map<String, dynamic>> decodingSample2() async =>
    parseJsonFromAssets('packages/japx/assets/decoding/decoding-2.json');
Future<Map<String, dynamic>> decodingSample3() async =>
    parseJsonFromAssets('packages/japx/assets/decoding/decoding-3.json');
Future<Map<String, dynamic>> decodingSample4() async =>
    parseJsonFromAssets('packages/japx/assets/decoding/decoding-4.json');
Future<Map<String, dynamic>> decodingSample5() async =>
    parseJsonFromAssets('packages/japx/assets/decoding/decoding-5.json');
Future<Map<String, dynamic>> decodingSample6() async =>
    parseJsonFromAssets('packages/japx/assets/decoding/decoding-6.json');
Future<Map<String, dynamic>> decodingSample7() async =>
    parseJsonFromAssets('packages/japx/assets/decoding/decoding-7.json');

Future<Map<String, dynamic>> encodingSample1() async =>
    parseJsonFromAssets('packages/japx/assets/encoding/encoding-1.json');
Future<Map<String, dynamic>> encodingSample2() async =>
    parseJsonFromAssets('packages/japx/assets/encoding/encoding-2.json');
Future<Map<String, dynamic>> encodingSample3() async =>
    parseJsonFromAssets('packages/japx/assets/encoding/encoding-3.json');
Future<Map<String, dynamic>> encodingSample4() async =>
    parseJsonFromAssets('packages/japx/assets/encoding/encoding-4.json');
Future<Map<String, dynamic>> encodingSample5() async =>
    parseJsonFromAssets('packages/japx/assets/encoding/encoding-5.json');
Future<Map<String, dynamic>> encodingSample6() async =>
    parseJsonFromAssets('packages/japx/assets/encoding/encoding-6.json');

Future<Map<String, dynamic>> resultDecoding1() async => parseJsonFromAssets(
    'packages/japx/assets/result/decoding/result-decoding-1.json');
Future<Map<String, dynamic>> resultDecoding2() async => parseJsonFromAssets(
    'packages/japx/assets/result/decoding/result-decoding-2.json');
Future<Map<String, dynamic>> resultDecoding3() async => parseJsonFromAssets(
    'packages/japx/assets/result/decoding/result-decoding-3.json');
Future<Map<String, dynamic>> resultDecoding4() async => parseJsonFromAssets(
    'packages/japx/assets/result/decoding/result-decoding-4.json');
Future<Map<String, dynamic>> resultDecoding5() async => parseJsonFromAssets(
    'packages/japx/assets/result/decoding/result-decoding-5.json');
Future<Map<String, dynamic>> resultDecoding6() async => parseJsonFromAssets(
    'packages/japx/assets/result/decoding/result-decoding-6.json');
Future<Map<String, dynamic>> resultDecoding7() async => parseJsonFromAssets(
    'packages/japx/assets/result/decoding/result-decoding-7.json');

Future<Map<String, dynamic>> resultEncoding1() async => parseJsonFromAssets(
    'packages/japx/assets/result/encoding/result-encoding-1.json');
Future<Map<String, dynamic>> resultEncoding2() async => parseJsonFromAssets(
    'packages/japx/assets/result/encoding/result-encoding-2.json');
Future<Map<String, dynamic>> resultEncoding3() async => parseJsonFromAssets(
    'packages/japx/assets/result/encoding/result-encoding-3.json');
Future<Map<String, dynamic>> resultEncoding4() async => parseJsonFromAssets(
    'packages/japx/assets/result/encoding/result-encoding-4.json');
Future<Map<String, dynamic>> resultEncoding5() async => parseJsonFromAssets(
    'packages/japx/assets/result/encoding/result-encoding-5.json');
Future<Map<String, dynamic>> resultEncoding6() async => parseJsonFromAssets(
    'packages/japx/assets/result/encoding/result-encoding-6.json');

Future<Map<String, dynamic>> parseJsonFromAssets(String assetsPath) async =>
    jsonDecode(await rootBundle.loadString(assetsPath));
