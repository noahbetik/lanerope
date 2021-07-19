import 'package:cloud_firestore/cloud_firestore.dart';

class NewGroup {
  final String groupName;
  NewGroup(this.groupName);
  CollectionReference groups = FirebaseFirestore.instance.collection('groups');

  Future<void> addGroup() {
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
