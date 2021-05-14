import 'package:flutter/material.dart';
import 'dart:io';
import 'athleteInfo.dart';
import 'calendar.dart';
import 'coachDM.dart';
import 'forms.dart';
import 'home.dart';
import "settings.dart";

bool ios = Platform.isIOS;
bool android = Platform.isAndroid;

class AthleteInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Athlete Info")),
        body: Material(),
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
  }
}