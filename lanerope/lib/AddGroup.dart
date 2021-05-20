import 'package:cloud_firestore/cloud_firestore.dart';

class AddGroup {
  final String groupName;
  AddGroup(this.groupName);
  CollectionReference groups = FirebaseFirestore.instance.collection('groups');

  Future<void> addGroup() {
    // Call the user's CollectionReference to add a new user
    return groups
        .doc(groupName)
        .set({
      'size' : 0,
      'coaches' : <String>[], // maybe use this for updating arrays: FieldValue.arrayUnion(<String>[]),
      'athletes' : <String>[],
      'parents' : <String>[],
    })
        .then((value) => print("Group Added"))
        .catchError((error) => print("Failed to add group: $error"));
  }
}
