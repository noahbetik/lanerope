import 'package:cloud_firestore/cloud_firestore.dart';

// add name, gender, pronouns

class AddUser {
  final String uid;
  final String role;
  final String firstName;
  final String lastName;
  final String gender;
  String age;
  final DateTime birthday;

  AddUser(this.uid, this.role, this.firstName, this.lastName, this.gender,
      this.age, this.birthday);

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addUser() {
    // Call the user's CollectionReference to add a new user
    return users
        .doc(uid)
        .set({
          'uid': uid,
          'role': role,
          'first_name': firstName,
          'last_name': lastName,
          'gender': gender,
          'age': age,
          'birthday': birthday,
          'groups': <String>['unassigned'],
          'convos': <String>[]
          // want nested something for parent/athlete/coach/relations
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }
}
