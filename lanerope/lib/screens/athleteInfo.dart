import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lanerope/pagesDrawer.dart' as pd;
import 'package:lanerope/globals.dart' as globals;

bool ios = Platform.isIOS;
bool android = Platform.isAndroid;
CollectionReference athleteWrangler =
    FirebaseFirestore.instance.collection('users');
Map allAthletes = new Map();

List<String> getInfo(String uid) {
  String fName = '';
  String lName = '';
  String fullName = '';
  String age = '';
  String group = '';
  String gender = '';
  String birthday = '';
  print("getting info for " + uid);
  athleteWrangler.doc(uid).get().then((DocumentSnapshot snapshot) {
    fName = snapshot.get("first_name");
    lName = snapshot.get("last_name");
    fullName = fName + " " + lName;
    age = snapshot.get("age");
    gender = snapshot.get("gender");
    group = List.from(snapshot.get("groups"))[0];
    birthday = snapshot.get("birthday").toString();

    print("info complete for " + fullName);
  });
  return [fName, lName, fullName, age, group, gender, birthday];
}

Future<void> allInfo() async {
  if (globals.role == 'Coach/Admin'){
    athleteWrangler.get().then((snapshot) {
      snapshot.docs.forEach((element) {
        allAthletes[element.id] = getInfo(element.id);
      });
    });
  }
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
