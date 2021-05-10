import 'package:flutter/material.dart';
import './screens/home.dart';
import "./screens/account.dart";
import "./screens/login.dart";
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Widget _defaultHome = Login();
  final prefs = await SharedPreferences.getInstance();

  final bool _status = prefs.getBool("login") ?? false;
  print(_status);

  /*if (_loggedIn) {
    _defaultHome == Home();
  }*/

  runApp(new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Lanerope",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _status == true ? Home() : Login(),
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
