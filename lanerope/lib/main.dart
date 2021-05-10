import 'package:flutter/material.dart';
import './screens/home.dart';
import "./screens/account.dart";
import "./screens/login.dart";
import 'dart:io';

void main() {
  // this might be good as an async once db connection is made
  Widget _defaultHome = Login();

  bool _result = true;

  if (_result) {
    _defaultHome == Home();
  }

  runApp(new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Lanerope",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _defaultHome,
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => new Home(),
        '/login': (BuildContext context) => new Login()
      }));
}

/*class LaneropeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Lanerope",
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Home());
  }
}*/
