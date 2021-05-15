import 'package:cloud_firestore/cloud_firestore.dart';

String currentUID = '';
String role = '';

Future<String> findRole() async {
  final CollectionReference users = FirebaseFirestore.instance.collection('users');
  await users.doc(currentUID).get().then((DocumentSnapshot snapshot){
    role = snapshot.get("role");
  });

  print(currentUID);
  print(role);

  return role;
}