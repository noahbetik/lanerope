import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lanerope/pagesDrawer.dart' as pd;
import 'package:shared_preferences/shared_preferences.dart';

bool ios = Platform.isIOS;
bool android = Platform.isAndroid;

class Settings extends StatelessWidget {
  final double boxHeight = 60.0;
  final double textSize = 16.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: pd.PagesDrawer().importDrawer(context),
        appBar: AppBar(title: Text("Settings")),
        body: Material(
            child: ListView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: boxHeight,
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.black26))),
              child: IconButton(
                icon: Text("Log out", style: TextStyle(fontSize: textSize)),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  final prefs = await SharedPreferences.getInstance();
                  prefs.setBool("login", false);
                  Navigator.of(context).pushReplacementNamed('/login');
                },
                alignment: Alignment.centerLeft,
              ),
            ),
            Container(
              height: boxHeight,
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.black26))),
              child: IconButton(
                icon: Text("Button 2", style: TextStyle(fontSize: textSize)),
                onPressed: () {},
                alignment: Alignment.centerLeft,
              ),
            ),
            Container(
              height: boxHeight,
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.black26))),
              child: IconButton(
                icon: Text("Button 3", style: TextStyle(fontSize: textSize)),
                onPressed: () {},
                alignment: Alignment.centerLeft,
              ),
            )
          ],
        )));
  }
}
