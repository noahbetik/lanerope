import 'package:flutter/material.dart';
import 'dart:io';

bool ios = Platform.isIOS;
bool android = Platform.isAndroid;

class Settings extends StatelessWidget {

  double height = 10.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Settings")),
        body: Material(
            child: Row(children: <Widget>[
          Expanded(
              child: IconButton(
                  icon: Text("Log out"),
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/login');
                  },
              alignment: Alignment.centerLeft,))
        ])));
  }
}
