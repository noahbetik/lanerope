import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';

// add name, gender, pronouns

class AddUser {
  final String uid;
  final String firstName;
  final String lastName;
  final String role;

  AddUser(this.uid, this.firstName, this.lastName, this.role);

  // Create a CollectionReference called users that references the firestore collection
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addUser() {
    // Call the user's CollectionReference to add a new user
    return users
        .doc(uid)
        .set({
          'uid': uid,
          'first_name': firstName,
          'last_name': lastName,
          'role': role,
          'groups' : <String>[],
          // want nested something for parent/athlete/coach/relations
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }
}
