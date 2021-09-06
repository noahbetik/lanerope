import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lanerope/globals.dart' as globals;

import 'MessageView.dart';

final CollectionReference messages =
    FirebaseFirestore.instance.collection('messages');
final CollectionReference users =
    FirebaseFirestore.instance.collection('users');

class ConvoTile extends StatelessWidget {
  final String name; // name of other person
  final String lastMsg; // most recent message preview
  final String timestamp;
  final String cID; // firestore document id of convo
  final String id; // firestore UID of other user
  final bool newMsg; // used for tile formatting

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
    // bolded convo tile text when most recent message is unread and from other user

    if (this.cID == ''){
      // use default if the convo doesn't exist yet
      // i.e. this tile is in the full list of all contacts
      return ListTile(
        title: Text(this.name, style: ts),
        subtitle: Text(this.lastMsg, style: ts),
        trailing: Text(this.timestamp, style: ts),
        onTap: () async {
          // create the convo
          String docID = '';
          // firstly in messages db
          await messages.add({
            "participants": [globals.currentUID, this.id],
            "messages": [],
            "status": "old"
          }).then((doc) {
            docID = doc.id;
            // this gets put in each user's document
            // provides a reference to the convo
          });
          users.doc(globals.currentUID).update({
            'convos': FieldValue.arrayUnion([docID])
          }); // update for creating user
          users.doc(this.id).update({
            'convos': FieldValue.arrayUnion([docID])
          }); // update for other user
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MessageView(
                    convoName: this.name,
                    chatID: docID
                  )));
        },
        dense: true,
      );
    }

    return StreamBuilder<DocumentSnapshot>(
      // monitors this specific document (conversation) inside messages db
        stream: messages.doc(this.cID).snapshots(),
        builder: (context, snap) {
          List msgs;
          int len;
          if (snap.hasData) {
            // extract data (message, timestamp, sender, read status)
            String recent = snap.data!.get("status");
            msgs = snap.data!.get("messages");
            len = msgs.length;
            if ((recent == "sent" || recent == "delivered") &&
                msgs[len - 1].split(globals.splitSeq)[2] != globals.currentUID) {
              ts = TextStyle(fontWeight: FontWeight.bold);
              // bold if message unread
            }
            else {
              ts = TextStyle(fontWeight: FontWeight.normal);
            }
            String dbMessage = '';
            if (len > 0){
              dbMessage = msgs[len-1].split(globals.splitSeq)[0];
              if (dbMessage.startsWith("https://firebasestorage.googleapis.com/v0/b/lanerope-nb.appspot.com/o/image_cropper")){
                dbMessage = "<Image>";
                // don't want to display the image link as the message preview
              }
            }

            else {
              dbMessage = "Start the conversation!";
            }


            return ListTile(
              title: Text(this.name, style: ts),
              subtitle: Text(dbMessage, style: ts),
              trailing: Text('', style: ts),
              onTap: () async {
                if (len > 0) {
                  if (msgs[len - 1].split(globals.splitSeq)[2] != globals.currentUID) {
                    messages.doc(this.cID).update({"status": "received"});
                    // update message status
                  }
                }
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MessageView(
                          convoName: this.name,
                          chatID: this.cID
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
