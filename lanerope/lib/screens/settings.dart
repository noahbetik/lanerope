import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lanerope/globals.dart' as globals;
import 'athleteInfo.dart';
import 'calendar.dart';
import 'coachDM.dart';
import 'forms.dart';
import 'home.dart';

bool ios = Platform.isIOS;
bool android = Platform.isAndroid;

class Settings extends StatelessWidget {
  final double boxHeight = 60.0;
  final double textSize = 16.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text('Pages',
                    style: TextStyle(color: Colors.white, fontSize: 24.0)),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              ListTile(
                title: Text('Home'),
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Home()),
                      (Route<dynamic> route) => false);
                },
              ),
              ListTile(
                title: Text('Calendar'),
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Calendar()),
                      (Route<dynamic> route) => false);
                },
              ),
              ListTile(
                title: Text('Forms'),
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Forms()),
                      (Route<dynamic> route) => false);
                },
              ),
              ListTile(
                title: Text('Coach DM'),
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => CoachDM()),
                      (Route<dynamic> route) => false);
                },
              ),
              ListTile(
                title: Text('Athlete Info'),
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => AthleteInfo()),
                      (Route<dynamic> route) => false);
                },
              ),
              if (globals.role == "Coach/Admin")
                ListTile(
                  title: Text('Admin Page'),
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => Settings()),
                        (Route<dynamic> route) => false);
                  },
                ),
              ListTile(
                title: Text('Settings'),
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Settings()),
                      (Route<dynamic> route) => false);
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(title: Text("Settings")),
        body: Material(
            child: ListView(
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
