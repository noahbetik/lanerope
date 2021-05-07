import 'package:flutter/material.dart';
import 'dart:io';

bool ios = Platform.isIOS;
bool android = Platform.isAndroid;

class Athlete extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Athlete Info")),
        body: Material()
    );
  }
}