import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyState createState() {
    return _MyState();
  }
}

class _MyState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text("Flutter Flat Button"),
      ),
      body: Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          alignment: Alignment.topCenter,
          child: FlatButton(
            child: Text("Button"),
            onPressed: () {},
          )),
    ));
  }
}
