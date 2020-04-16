import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:japx/japx.dart';
import 'package:japx_example/user_model.dart';

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
  String secondString;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          RaisedButton(
            onPressed: mockAPICall,
            child: Text('Mock API Call'),
          ),
          const SizedBox(
            height: 100,
          ),
          secondString == null ? SizedBox.shrink() : Text('$secondString'),
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
    final Map<String, dynamic> encodedData = japxEncode(requestData);
    print(encodedData.toString());

    await Future<void>.delayed(Duration(seconds: 2));

    final jsonApi = await parseJsonFromAssets("assets/api-response.json");
    print(jsonApi);
    print('---------------');
    final json = japxDecode(jsonApi);
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
