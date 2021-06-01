import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lanerope/pagesDrawer.dart' as pd;
import 'package:lanerope/globals.dart' as globals;

bool ios = Platform.isIOS;
bool android = Platform.isAndroid;
CollectionReference athleteWrangler =
    FirebaseFirestore.instance.collection('users');

String thisFName = '';
String thisLName = '';
String thisFullName = '';
String thisAge = '';
String thisGroup = '';
String thisGender = '';
String thisBirthday = '';

Future<void> getInfo(String uid) async {
  print("getting info for " + uid);
  athleteWrangler.doc(uid).get().then((DocumentSnapshot snapshot) {
    thisFName = snapshot.get("first_name");
    thisLName = snapshot.get("last_name");
    thisFullName = thisFName + " " + thisLName;
    thisAge = snapshot.get("age");
    thisGender = snapshot.get("gender");
    thisGroup = List.from(snapshot.get("groups"))[0];
    thisBirthday = snapshot.get("birthday").toString();

    print("info complete for " + thisFullName);
  });
}

class AthleteInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Athlete Info")),
        body: Material(),
        drawer: pd.PagesDrawer().importDrawer(context));
  }
}

// search bar for coach
// yourself for athlete
// children for parent/guardian

class AdminSearch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
