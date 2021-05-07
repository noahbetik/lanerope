import 'package:flutter/material.dart';
import 'dart:io';

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