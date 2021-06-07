import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lanerope/globals.dart' as globals;
import 'package:lanerope/pagesDrawer.dart' as pd;

bool ios = Platform.isIOS;
bool android = Platform.isAndroid;
FirebaseAuth auth = FirebaseAuth.instance;
final CollectionReference users =
    FirebaseFirestore.instance.collection('users');

String sayHi() {
  String hello;
  DateTime now = new DateTime.now();
  int hour = now.hour;
  if (globals.name == '') {
    globals.findRole();
  }
  String name = globals.name;
  if (hour < 12) {
    hello = "good morning " + name;
  } else if (hour < 18) {
    hello = "good afternoon " + name;
  } else {
    hello = "good evening " + name;
  }
  return hello + "\nYou are a " + globals.role;
}

List<Widget> announcementList = [
  Text(sayHi(),
      textDirection: TextDirection.ltr,
      style: TextStyle(color: Colors.black, fontSize: 36.0)),
  Announcement(),
  Announcement(),
  Announcement()
];

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Lanerope")),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            print("yuh");
          },
        ),
        body: ListView.builder(
          padding: EdgeInsets.all(8.0),
          itemCount: announcementList.length,
          itemBuilder: (context, index) {
            return announcementList[index];
          },
        ),
        drawer: pd.PagesDrawer().importDrawer(context));
  }
}

class Announcement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
        child: Container(
            padding: EdgeInsets.all(8.0),
            child: Column(children: [
              Text("the title", style: Theme.of(context).textTheme.headline1),
              Text("the subtitle is optional perhaps",
                  style: Theme.of(context).textTheme.subtitle1),
              Text("body text goes here " * 10,
                  textDirection: TextDirection.ltr,
                  style: Theme.of(context).textTheme.bodyText1),
            ])));
  }
}
