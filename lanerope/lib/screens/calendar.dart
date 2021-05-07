import 'package:flutter/material.dart';
import 'dart:io';
import './screens/home.dart';


bool ios = Platform.isIOS;
bool android = Platform.isAndroid;

class Calendar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Calendar")),
        body: Material()
    );
  }
}