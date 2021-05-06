import 'package:flutter/material.dart';
import 'dart:io';

bool ios = Platform.isIOS;
bool android = Platform.isAndroid;

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
                child: Text('Drawer Header'),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              ListTile(
                title: Text('Calendar'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Forms'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Coach DM'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text(''),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
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
    if (hour < 12){
      hello = "good morning dawg";
    }
    else if (hour < 18){
      hello = "good afternoon dawg";
    }
    else{
      hello = "good evening dawg";
    }

    String minutes = (minute < 10) ? "0" + minute.toString() : minute.toString();

    return "The time is " + hour.toString() + ":" + minutes + "\n" + hello;
  }
}
