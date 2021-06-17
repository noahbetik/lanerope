library lanerope.globals;

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
StreamController<bool> complete = StreamController<bool>.broadcast();
Stream<bool> redraw = complete.stream; // maybe wanna make this global some day
bool loaded = false;


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
    fullName = name + " " + snapshot.get("last_name");
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
  try {
    group = List.from(
        snapshot.get("groups"))[0]; // gonna have to fix for multiple groups
  } catch (RangeError) {
    print("no group assigned yet");
  }
  int timestamp = snapshot.get("birthday").seconds;
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  birthday =
      formatter.format(DateTime.fromMillisecondsSinceEpoch(timestamp * 1000));
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
  print("getting all info");
}

Future<int> announcementID() async {
  int id = 0;
  await stats.doc("announcements").get().then((snap) {
    id = snap.get("count");
  });
  int temp = id;
  stats.doc("announcements").set({"count": ++temp});
  return id;
}

List<Announcement> announcementList = [];

Future<List<dynamic>> _getAnnouncement(String docTitle) async {
  print("getting announcement " + docTitle);
  DocumentSnapshot snap = await announcements.doc(docTitle).get();
  String title = await snap.get("title_text");
  String text = await snap.get("main_text");
  String imgURL = await snap.get("header_image");
  String author = await snap.get("author");
  String date = await snap.get("date");
  int id = await snap.get("id");
  Image img = Image.network(imgURL, fit: BoxFit.cover);
  return [title, text, img, author, date, id];
}

void sort(List<Announcement> ans) {
  // do a better sorting algorithm
  int n = ans.length;
  for (int i = 0; i < n - 1; i++) {
    for (int j = 0; j < n - i - 1; j++) {
      if (ans[j].id < ans[j + 1].id) {
        Announcement temp = ans[j];
        ans[j] = ans[j + 1];
        ans[j + 1] = temp;
        print("swap em");
      }
    }
  }
  complete.add(true);
}

void allAnnouncements() async {
  // it still feels stupid to do it this way but whatever
  announcementList.clear();
  QuerySnapshot snap = await announcements.get();
  List items = snap.docs;
  for(int i=0; i<items.length; i++){
    List<dynamic> info = await _getAnnouncement(items[i].id);
    announcementList.add(
        Announcement(info[0], info[1], info[2], info[3], info[4], info[5]));
  }

  print("did it reflect?");
  print(announcementList);
  complete.add(true);
  loaded = true;
}
