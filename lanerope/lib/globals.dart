library lanerope.globals;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

String currentUID = '';
String role = '';
String name = '';
List<String> managedGroups = [];
Map allAthletes = new Map();
final CollectionReference users = FirebaseFirestore.instance.collection('users');
final CollectionReference groups = FirebaseFirestore.instance.collection('groups');

Future<String> findRole() async {
  await users.doc(currentUID).get().then((DocumentSnapshot snapshot){
    role = snapshot.get("role");
  });
  print(currentUID);
  print(role);
  return role;
}

void getUID () {
  currentUID = FirebaseAuth.instance.currentUser!.uid;
}

void allGroups() {
  groups.get().then((snapshot) {
    managedGroups.clear();
    snapshot.docs.forEach((element) {
      managedGroups.add(element.id);
    });
  });
}

List<String> getInfo(String uid) {
  String fName = '';
  String lName = '';
  String fullName = '';
  String age = '';
  String group = '';
  String gender = '';
  String birthday = '';
  print("getting info for " + uid);
  users.doc(uid).get().then((DocumentSnapshot snapshot) { // CHANGES NOT REFLECTED OUT OF SCOPE
    fName = snapshot.get("first_name");
    lName = snapshot.get("last_name");
    fullName = fName + " " + lName;
    age = snapshot.get("age");
    gender = snapshot.get("gender");
    group = List.from(snapshot.get("groups"))[0];
    birthday = snapshot.get("birthday").toString();
    //print("info complete for " + fullName);
  });
  print([fName, lName, fullName, age, group, gender, birthday]);
  return [fName, lName, fullName, age, group, gender, birthday];
}

Future<void> allInfo() async {
  if (role == 'Coach/Admin'){
    users.get().then((snapshot) {
      snapshot.docs.forEach((element) {
        allAthletes[element.id] = getInfo(element.id);
        print(allAthletes);
      });
    });
  }
}
