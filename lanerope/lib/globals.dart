import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

String currentUID = '';
String role = '';
String name = '';
List<String> managedGroups = [];
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