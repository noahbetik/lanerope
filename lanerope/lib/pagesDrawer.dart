import 'package:flutter/material.dart';
import 'package:lanerope/screens/adminPanel.dart';
import 'package:lanerope/screens/athleteInfo.dart';
import 'package:lanerope/screens/calendar.dart';
import 'package:lanerope/screens/coachDM.dart';
import 'package:lanerope/screens/forms.dart';
import 'package:lanerope/screens/home.dart';
import 'package:lanerope/screens/settings.dart';

import 'globals.dart' as globals;

class PagesDrawer extends Drawer {

  importDrawer(context) {
    return new Drawer(
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
                    MaterialPageRoute(builder: (context) => AdminPanel()),
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
    );
  }
}