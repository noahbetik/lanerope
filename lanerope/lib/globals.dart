library lanerope.globals;

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lanerope/screens/calendar.dart';
import 'package:lanerope/screens/home.dart';
import 'package:lanerope/DM/ConvoTile.dart';

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
final CollectionReference messages =
    FirebaseFirestore.instance.collection('messages');

///***************************************************************************
/// VARIABLES

String currentUID = '';
String role = '';
String name = '';
String fullName = '';
List<dynamic> myGroups = [];

int annID = 0;
List<String> everyGroup = ['unassigned'];
Map allAthletes = new Map();
StreamController<bool> complete = StreamController<bool>.broadcast();
Stream<bool> redraw = complete.stream; // maybe wanna make this global some day

bool loaded = false;
bool subLock = false;

Future<String> findRole() async {
  if (currentUID.isEmpty) {
    getUID();
  }
  await users.doc(currentUID).get().then((DocumentSnapshot snapshot) {
    role = snapshot.get("role");
    name = snapshot.get("first_name");
    fullName = name + " " + snapshot.get("last_name");
    myGroups = snapshot.get("groups");
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
    everyGroup.clear();
    everyGroup.add('unassigned');
    snapshot.docs.forEach((element) {
      everyGroup.add(element.id);
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

  complete.add(true);
  loaded = true;
}

/// ***********************************************************************
/// CALENDAR

Map<String, List> events = {};

Future<CalendarThing> getEvent(String docTitle) async {
  DocumentSnapshot snap = await calendar.doc(docTitle).get();
  String title = await snap.get("title");
  List dates = await snap.get("repeats");
  String length = await snap.get("duration");
  dynamic timestamp = await snap.get("start");
  DateTime begin = DateTime.parse(timestamp.toDate().toString());

  return CalendarThing(length, begin, occurrences: dates, title: title);
}

void allEvents() async {
  events.clear();
  QuerySnapshot snap = await calendar.get();
  List items = snap.docs;
  for (int i = 0; i < items.length; i++) {
    CalendarThing thatEvent = await getEvent(items[i].id);
    for (String date in thatEvent.occurrences) {
      if (events.containsKey(date)) {
        events[date]?.add(thatEvent);
      } else {
        events[date] = [thatEvent];
      }
    }
  }
}

/// ***********************************************************************
/// DM

List contacts = [];

Future<Map?> oneContact(String id) async {
  DocumentSnapshot snap = await users.doc(id).get();
  String name =
      await snap.get("first_name") + " " + await snap.get("last_name");
  List group = await snap.get("groups");
  int age = int.parse(await snap.get("age"));

  if (age >= 13) {
    return {"name": name, "group": group, "id": id};
  } else
    return null;
}

void getContacts() async {
  if (role == "Coach/Admin") {
    // all parents
    // athletes 13+
    contacts.clear();
    QuerySnapshot snap = await users.get();
    List<DocumentSnapshot> items = snap.docs;
    for (int i = 0; i < items.length; i++) {
      Map? info = await oneContact(items[i].id);
      contacts.add(info);
    }
  } else if (role == "Parent/Guardian" || role == "Athlete") {
    // group coaches only
    // age checking done in oneContact() function
    contacts.clear();
    QuerySnapshot snap = await users.get();
    List items = snap.docs;
    for (int i = 0; i < items.length; i++) {
      if (items[i].get("role") == "Coach/Admin") {
        Map? info = await oneContact(items[i].id);
        if (myGroups.contains(info!["groups"][0])) {
          // need to fix for coaches w multiple groups
          contacts.add(info);
        }
      }
    }
  }
}

List convos = [];

void getConvos() async {
  var snap = await users.doc(currentUID).get();
  List cvs = snap.get('convos');
  for (String c in cvs){
    List temp = await convoInfo(c);
    String text = temp[2].split("⛄𝄞⛄")[0];
    print(text);
    convos.add(ConvoTile(cID: c, id: temp[0], name: temp[1], lastMsg: text));
  }
}

Future<List> convoInfo (String convoID) async {
  List info = [];
  print("getting convo " + convoID);
  var cv = await messages.doc(convoID).get();
  List temp = cv.get('participants');
  info.add(temp[0] == currentUID ? temp[1] : temp[0]); // other UID
  var other = await users.doc(info[0]).get();
  print("this that");
  print(info[0]);
  info.add(other.get("first_name") + " " + other.get("last_name")); // name
  temp = cv.get('messages');
  int len = temp.length;
  info.add(temp[len-1]); // last msg
  return info;
}