import 'dart:convert';
import 'dart:io';

Future<Map<String, dynamic>> decodingSample1() async =>
    parseJsonFromPath('assets/decoding/decoding-1.json');

Future<Map<String, dynamic>> decodingSample2() async =>
    parseJsonFromPath('assets/decoding/decoding-2.json');

Future<Map<String, dynamic>> decodingSample3() async =>
    parseJsonFromPath('assets/decoding/decoding-3.json');

Future<Map<String, dynamic>> decodingSample4() async =>
    parseJsonFromPath('assets/decoding/decoding-4.json');

Future<Map<String, dynamic>> decodingSample5() async =>
    parseJsonFromPath('assets/decoding/decoding-5.json');

Future<Map<String, dynamic>> decodingSample6() async =>
    parseJsonFromPath('assets/decoding/decoding-6.json');

Future<Map<String, dynamic>> decodingSample7() async =>
    parseJsonFromPath('assets/decoding/decoding-7.json');

Future<Map<String, dynamic>> encodingSample1() async =>
    parseJsonFromPath('assets/encoding/encoding-1.json');

Future<Map<String, dynamic>> encodingSample2() async =>
    parseJsonFromPath('assets/encoding/encoding-2.json');

Future<Map<String, dynamic>> encodingSample3() async =>
    parseJsonFromPath('assets/encoding/encoding-3.json');

Future<Map<String, dynamic>> encodingSample4() async =>
    parseJsonFromPath('assets/encoding/encoding-4.json');

Future<Map<String, dynamic>> encodingSample5() async =>
    parseJsonFromPath('assets/encoding/encoding-5.json');

Future<Map<String, dynamic>> encodingSample6() async =>
    parseJsonFromPath('assets/encoding/encoding-6.json');

Future<Map<String, dynamic>> resultDecoding1() async =>
    parseJsonFromPath('assets/result/decoding/result-decoding-1.json');

Future<Map<String, dynamic>> resultDecoding2() async =>
    parseJsonFromPath('assets/result/decoding/result-decoding-2.json');

Future<Map<String, dynamic>> resultDecoding3() async =>
    parseJsonFromPath('assets/result/decoding/result-decoding-3.json');

Future<Map<String, dynamic>> resultDecoding4() async =>
    parseJsonFromPath('assets/result/decoding/result-decoding-4.json');

Future<Map<String, dynamic>> resultDecoding5() async =>
    parseJsonFromPath('assets/result/decoding/result-decoding-5.json');

Future<Map<String, dynamic>> resultDecoding6() async =>
    parseJsonFromPath('assets/result/decoding/result-decoding-6.json');

Future<Map<String, dynamic>> resultDecoding7() async =>
    parseJsonFromPath('assets/result/decoding/result-decoding-7.json');

Future<Map<String, dynamic>> resultEncoding1() async =>
    parseJsonFromPath('assets/result/encoding/result-encoding-1.json');

Future<Map<String, dynamic>> resultEncoding2() async =>
    parseJsonFromPath('assets/result/encoding/result-encoding-2.json');

Future<Map<String, dynamic>> resultEncoding3() async =>
    parseJsonFromPath('assets/result/encoding/result-encoding-3.json');

Future<Map<String, dynamic>> resultEncoding4() async =>
    parseJsonFromPath('assets/result/encoding/result-encoding-4.json');

Future<Map<String, dynamic>> resultEncoding5() async =>
    parseJsonFromPath('assets/result/encoding/result-encoding-5.json');

Future<Map<String, dynamic>> resultEncoding6() async =>
    parseJsonFromPath('assets/result/encoding/result-encoding-6.json');

Future<Map<String, dynamic>> parseJsonFromPath(String assetsPath) async {
  Map<String, dynamic>? json =
      jsonDecode(await File(assetsPath).readAsString());
  if (json == null) {
    throw 'Unable to read file $assetsPath';
  }
  return json;
}
