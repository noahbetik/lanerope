import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lanerope/globals.dart' as globals;
import 'package:lanerope/pagesDrawer.dart' as pd;

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
      drawer: pd.PagesDrawer().importDrawer(context)
    );
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

    String timeString =
        "The time is " + hour.toString() + ":" + minutes + "\n" + hello;

    return timeString + "\nYou are a " + globals.role;
  }
}
