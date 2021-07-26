import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'MessageView.dart';
import 'package:lanerope/globals.dart' as globals;

final CollectionReference messages =
    FirebaseFirestore.instance.collection('messages');
final CollectionReference users =
    FirebaseFirestore.instance.collection('users');

class ConvoTile extends StatelessWidget {
  final String name;
  final String lastMsg;
  final String timestamp;
  final String id;

  ConvoTile(
      {this.name = '',
      this.lastMsg = '',
      this.timestamp = '',
      required this.id});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(this.name),
      subtitle: Text(this.lastMsg),
      trailing: Text(this.timestamp),
      onTap: () async {
        String docID = '';
        await messages.add({
          "participants": [globals.currentUID, this.id],
          "messages": [],
          "status": "old"
        }).then((doc) {
          docID = doc.id;
        });
        users.doc(globals.currentUID).update({
          'convos' : {FieldValue.arrayUnion([docID])}
        }); // update for creating user
        users.doc(this.id).update({
          'convos' : {FieldValue.arrayUnion([docID])}
        }); // update for other user
        print("docID is " + docID);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MessageView(
                      convoName: this.name,
                      chatID: docID,
                    )));
      },
      dense: true,
    );
  }
}
