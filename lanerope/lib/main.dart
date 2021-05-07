import 'package:flutter/material.dart';
import './screens/home.dart';
import "./screens/login.dart";
import 'dart:io';

void main() {
  runApp(new LaneropeApp());
}

class LaneropeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Lanerope",
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Login());
  }
}
