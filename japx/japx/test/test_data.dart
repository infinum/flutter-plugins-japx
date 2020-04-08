import 'dart:convert';

import 'package:flutter/services.dart';

Future<Map<String, dynamic>> decodingSample1() async {
  final jsonString = await rootBundle.loadString('assets/decoding-file-1.json');
  return jsonDecode(jsonString);
}
