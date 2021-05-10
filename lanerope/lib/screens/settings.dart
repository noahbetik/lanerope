import 'package:flutter/material.dart';
import 'dart:io';

bool ios = Platform.isIOS;
bool android = Platform.isAndroid;

class Settings extends StatelessWidget {
  final double boxHeight = 60.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Settings")),
        body: Material(
            child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: boxHeight,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.black26))),
              child: IconButton(
                icon: Text("Log out"),
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/login');
                },
                alignment: Alignment.centerLeft,
              ),
            ),
            Container(
              height: boxHeight,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.black26))),
              child: IconButton(
                icon: Text("Button 3"),
                onPressed: () {
                },
                alignment: Alignment.centerLeft,
              ),
            ),
            Container(
              height: boxHeight,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.black26))),
              child: IconButton(
                icon: Text("Button 3"),
                onPressed: () {
                },
                alignment: Alignment.centerLeft,
              ),
            )
          ],
        )));
  }
}
