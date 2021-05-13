import 'package:flutter/material.dart';
import 'package:lanerope/screens/calendar.dart';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'calendar.dart';
import 'forms.dart';
import 'coachDM.dart';
import 'athleteInfo.dart';
import 'settings.dart';

bool ios = Platform.isIOS;
bool android = Platform.isAndroid;
FirebaseAuth auth = FirebaseAuth.instance;

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lanerope")),
      body: Material(
        color: Colors.white,
        child: Center(
            child: Text(sayHi(),
                textDirection: TextDirection.ltr,
                style: TextStyle(color: Colors.black, fontSize: 36.0))),
      ),
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
    );

    /*Material(
        color: Colors.white,
        child: Center(
            child: Text(sayHi(),
                textDirection: TextDirection.ltr,
                style: TextStyle(color: Colors.black, fontSize: 36.0))),
      );*/
  }

  String sayHi() {
    String hello;
    DateTime now = new DateTime.now();
    int hour = now.hour;
    int minute = now.minute;
    if (hour < 12) {
      hello = "good morning dawg";
    } else if (hour < 18) {
      hello = "good afternoon dawg";
    } else {
      hello = "good evening dawg";
    }

    String minutes =
        (minute < 10) ? "0" + minute.toString() : minute.toString();

    return "The time is " + hour.toString() + ":" + minutes + "\n" + hello;
  }
}
