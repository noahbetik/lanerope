import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lanerope/pagesDrawer.dart' as pd;
import 'package:lanerope/globals.dart' as globals;

bool ios = Platform.isIOS;
bool android = Platform.isAndroid;
CollectionReference athleteWrangler =
    FirebaseFirestore.instance.collection('users');

String currentFName = '';
String currentLName = '';
String currentGroup = '';

void getInfo(String uid) async {
  await athleteWrangler.doc(uid).get().then((DocumentSnapshot snapshot) {
    currentFName = snapshot.get("first_name");
    currentLName = snapshot.get("last_name");
    currentGroup = List.from(snapshot.get("groups"))[0];
  });
  print(currentFName);
  print(currentLName);
  print(currentGroup);
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
