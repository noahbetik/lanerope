library lanerope.globals;

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lanerope/screens/calendar.dart';
import 'package:lanerope/screens/home.dart';

/// **************************************************************************
/// DATABASE REFERENCES
final CollectionReference users =
    FirebaseFirestore.instance.collection('users');
final CollectionReference groups =
    FirebaseFirestore.instance.collection('groups');
final CollectionReference announcements =
    FirebaseFirestore.instance.collection('announcements');
final CollectionReference stats =
    FirebaseFirestore.instance.collection('stats');
final CollectionReference calendar =
    FirebaseFirestore.instance.collection('calendar');

///***************************************************************************
/// VARIABLES

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
bool subLock = false;

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
    managedGroups.clear(); // name is causing confusion
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

/// ********************************************************************************
/// ANNOUNCEMENTS

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

Future<Map> getAnnouncement(String docTitle) async {
  print("getting announcement " + docTitle);
  DocumentSnapshot snap = await announcements.doc(docTitle).get();
  String title = await snap.get("title_text");
  String text = await snap.get("main_text");
  String imgURL = await snap.get("header_image");
  String author = await snap.get("author");
  String date = await snap.get("date");
  int id = await snap.get("id");
  Map result = {
    "title": title,
    "text": text,
    "author": author,
    "date": date,
    "id": id
  };
  if (imgURL != '') {
    result["image"] = Image.network(imgURL, fit: BoxFit.cover);
  }
  return result;
  //[title, text, img, author, date, id];
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
  for (int i = 0; i < items.length; i++) {
    Map info = await getAnnouncement(items[i].id);

    if (info.containsKey("image")) {
      announcementList.add(Announcement(info["title"], info["text"],
          info["author"], info["date"], info["id"], items[i].id,
          coverImage: info["image"]));
    } else {
      announcementList.add(Announcement(info["title"], info["text"],
          info["author"], info["date"], info["id"], items[i].id));
    }
  }

  print("did it reflect?");
  print(announcementList);
  complete.add(true);
  loaded = true;
}

/// ***********************************************************************
/// CALENDAR

Map<String, List> events = {}; // gotta implement events yourself

Future<CalendarThing> getEvent(String docTitle) async {
  DocumentSnapshot snap = await calendar.doc(docTitle).get();
  String title = await snap.get("title");
  List dates = await snap.get("repeats");
  String length = await snap.get("duration");
  return CalendarThing(length, occurrences: dates, title: title);
}


void allEvents() async {
  events.clear();
  QuerySnapshot snap = await calendar.get();
  List items = snap.docs;
  for (int i = 0; i < items.length; i++) {
    CalendarThing thatEvent = await getEvent(items[i].id);
    for (String date in thatEvent.occurrences){
      if (events.containsKey(date)){
        events[date]?.add(thatEvent);
      }
      else{
        events[date] = [thatEvent];
      }
    }
  }
  print(events);
}
