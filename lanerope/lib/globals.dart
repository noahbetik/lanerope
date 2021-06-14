library lanerope.globals;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lanerope/screens/home.dart';
import 'package:intl/intl.dart';


String currentUID = '';
String role = '';
String name = '';
String fullName = '';
int annID = 0;
List<String> managedGroups = ['unassigned'];
Map allAthletes = new Map();


final CollectionReference users =
    FirebaseFirestore.instance.collection('users');
final CollectionReference groups =
    FirebaseFirestore.instance.collection('groups');
final CollectionReference announcements =
FirebaseFirestore.instance.collection('announcements');
final CollectionReference stats =
FirebaseFirestore.instance.collection('stats');

Future<String> findRole() async {
  await users.doc(currentUID).get().then((DocumentSnapshot snapshot) {
    role = snapshot.get("role");
    name = snapshot.get("first_name");
    fullName = name + snapshot.get("last_name");
  });
  print(currentUID);
  print(role);
  return role;
}

void getUID() {
  currentUID = FirebaseAuth.instance.currentUser!.uid;
}

void allGroups() {
  groups.get().then((snapshot) {
    managedGroups.clear();
    managedGroups.add('unassigned');
    snapshot.docs.forEach((element) {
      managedGroups.add(element.id);
    });
  });
}

Future<List<String>> getInfo(String uid) async {
  String fName = '';
  String lName = '';
  String fullName = '';
  String age = '';
  String group = '';
  String gender = '';
  String birthday = '';
  DocumentSnapshot snapshot = await users.doc(uid).get();
  fName = snapshot.get("first_name");
  lName = snapshot.get("last_name");
  fullName = fName + " " + lName;
  age = snapshot.get("age");
  gender = snapshot.get("gender");
  try{
    group = List.from(snapshot.get("groups"))[0]; // gonna have to fix for multiple groups
  }
  catch (RangeError) {
    print("no group assigned yet");
  }
  int timestamp = snapshot.get("birthday").seconds;
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  birthday = formatter.format(DateTime.fromMillisecondsSinceEpoch(timestamp * 1000));
  return [fName, lName, fullName, age, group, gender, birthday];
}

Future<void> allInfo() async {
  if (role == 'Coach/Admin') {
    users.get().then((snapshot) {
      snapshot.docs.forEach((element) async {
        allAthletes[element.id] = await getInfo(element.id);
      });
    });
  }
}

Future<int> announcementID() async {
  int id = 0;
  await stats.doc("announcements").get().then((snap) {
    id = snap.get("count");
  });
  int temp = id;
  stats.doc("announcements").set({"count" : ++temp});
  return id;
}