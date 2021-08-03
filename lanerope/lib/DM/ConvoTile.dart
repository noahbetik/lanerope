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
  final String cID;
  final String id;
  final bool newMsg;

  ConvoTile(
      {this.name = '',
      this.lastMsg = '',
      this.timestamp = '',
      this.cID = '',
      required this.newMsg,
      required this.id});

  @override
  Widget build(BuildContext context) {
    TextStyle ts = TextStyle(fontWeight: FontWeight.normal);

    if (this.cID == ''){
      return ListTile(
        title: Text(this.name, style: ts),
        subtitle: Text(this.lastMsg, style: ts),
        trailing: Text(this.timestamp, style: ts),
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
            'convos': FieldValue.arrayUnion([docID])
          }); // update for creating user
          users.doc(this.id).update({
            'convos': FieldValue.arrayUnion([docID])
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

    return StreamBuilder<DocumentSnapshot>(
        stream: messages.doc(this.cID).snapshots(),
        builder: (context, snap) {
          List msgs;
          int len;
          if (snap.hasData) {
            String recent = snap.data!.get("status");
            msgs = snap.data!.get("messages");
            len = msgs.length;
            if ((recent == "sent" || recent == "delivered") &&
                msgs[len - 1].split("⛄𝄞⛄")[2] != globals.currentUID) {
              ts = TextStyle(fontWeight: FontWeight.bold);
            }
            else {
              ts = TextStyle(fontWeight: FontWeight.normal);
            }
            return ListTile(
              title: Text(this.name, style: ts),
              subtitle: Text(msgs[len-1].split("⛄𝄞⛄")[0], style: ts),
              trailing: Text('', style: ts),
              onTap: () async {
                if (msgs[len - 1].split("⛄𝄞⛄")[2] != globals.currentUID) {
                  messages.doc(this.cID).update({"status": "received"});
                }
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MessageView(
                          convoName: this.name,
                          chatID: this.cID,
                        )));
              },
              dense: true,
            );
          }
          else {
            return ListTile(title: Text("Loading..."));
          }
        });
  }
}
