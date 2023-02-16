// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:japx/japx.dart';
import 'package:japx_example/user_model.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Japx',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: const HomeScreen(),
        appBar: AppBar(
          title: const Text('Japx'),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? secondString;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          ElevatedButton(
            onPressed: mockAPICall,
            child: const Text('Mock API Call'),
          ),
          const SizedBox(
            height: 100,
          ),
          secondString == null
              ? const SizedBox.shrink()
              : Text('$secondString'),
        ],
      ),
    );
  }

  void mockAPICall() async {
    final User user = User('maroje.marcelic@infinum.com', 'Maroje Marcelic');

    Map<String, dynamic> requestData = <String, dynamic>{
      'type': 'users',
    };
    requestData.addAll(user.toMap());
    print(requestData.toString());
    print('---------------');
    final Map<String, dynamic> encodedData = Japx.encode(requestData);
    print(encodedData.toString());

    await Future<void>.delayed(const Duration(seconds: 2));

    final jsonApi = await parseJsonFromAssets("assets/api-response.json");
    print(jsonApi);
    print('---------------');
    final json = Japx.decode(jsonApi);
    print(json.toString());

    final User userFromApi = User.fromMap(json['data']);
    print('---------------');
    print(userFromApi.toString());

    setState(() {
      secondString = 'User received from api:\n${userFromApi.toString()}';
    });
  }

  Future<Map<String, dynamic>> parseJsonFromAssets(String assetsPath) async {
    print('--- Parse json from: $assetsPath');
    final jsonString = await rootBundle.loadString(assetsPath);
    return jsonDecode(jsonString);
  }
}
