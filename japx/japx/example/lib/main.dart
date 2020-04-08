import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:japx/japx.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Japx',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: HomeScreen(),
        appBar: AppBar(
          title: Text('Japx'),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String firstString;
  String secondString;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          RaisedButton(
            onPressed: decode,
            child: Text('Decode'),
          ),
          RaisedButton(
            onPressed: encode,
            child: Text('Encode'),
          ),
          Text('$firstString'),
          const SizedBox(
            height: 100,
          ),
          Text('$secondString'),
        ],
      ),
    );
  }

  void decode() async {
//    final jsonApi = await parseJsonFromAssets("assets/decoding-file-1.json");
    final jsonApi = 'aaa';
    print(jsonApi);
    print('---------------');
//    final json = jsonEncode(japxDecode(jsonApi));
    setState(() {
      firstString = jsonApi.toString();
//      secondString = json.toString();
    });
//    print(json.toString());
  }

  void encode() async {
    final json = await parseJsonFromAssets("assets/encoding-file-1.json");
    print(json);
    print('---------------');
    final jsonApi = jsonEncode(japxEncode(json));
    setState(() {
      firstString = json.toString();
      secondString = jsonApi.toString();
    });
    print(jsonApi);
  }

  Future<Map<String, dynamic>> parseJsonFromAssets(String assetsPath) async {
    print('--- Parse json from: $assetsPath');
    final jsonString = await rootBundle.loadString(assetsPath);
    return jsonDecode(jsonString);
  }
}
