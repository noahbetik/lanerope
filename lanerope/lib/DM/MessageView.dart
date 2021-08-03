import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'Message.dart';
import 'package:lanerope/globals.dart' as globals;

final CollectionReference messages =
    FirebaseFirestore.instance.collection('messages');

class MessageView extends StatelessWidget {
  final String convoName;
  final FocusNode _focus = new FocusNode();
  final _sCtrl = ScrollController();
  final TextEditingController msgCtrl = TextEditingController();
  final String chatID;
  final format = DateFormat("yyyy-MM-dd HH:mm");

  MessageView({required this.convoName, required this.chatID});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(title: Text(this.convoName)),
        body: StreamBuilder<DocumentSnapshot>(
          stream: messages.doc(chatID).snapshots(),
          builder: (context, snap) {
            if (!snap.hasData) {
              return SizedBox.shrink();
            } else {
              var ds = snap.data;
              /*_sCtrl.animateTo(
                _sCtrl.position.maxScrollExtent,
                duration: Duration(milliseconds: 500),
                curve: Curves.fastOutSlowIn,
              );*/
              return ListView.builder(
                controller: _sCtrl,
                  itemCount: ds!['messages'].length,
                  itemBuilder: (context, i) {
                    if (ds['messages'].length != 0) {
                      List info = ds['messages'][i].split("⛄𝄞⛄");
                      // has the potential to go buggy but makes db wayyyyyy simpler
                      // ⛄𝄞⛄
                      return Message(
                          text: info[0],
                          timestamp: info[1],
                          user: info[2] == globals.currentUID
                              ? Participant.you
                              : Participant.them,
                          chatID: this.chatID);
                    } else {
                      print("hek");
                      return SizedBox.shrink();
                    }
                  });
            }
          },
        ),
        bottomNavigationBar: Container(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 2),
              margin: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  color: Colors.grey[200]),
              child: Row(children: [
                SizedBox(width: 5),
                Material(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(100),
                    child: InkWell(
                      customBorder: CircleBorder(),
                      radius: 80,
                      onTap: () {},
                      splashColor: Colors.lightBlueAccent.withOpacity(0.5),
                      highlightColor: Colors.lightBlueAccent.withOpacity(0.5),
                      child: Container(
                        width: 42,
                        height: 42,
                        child: Icon(Icons.image),
                      ),
                    )),
                SizedBox(width: 4),
                Expanded(
                    child: TextField(
                  focusNode: _focus,
                  controller: msgCtrl,
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: 10,
                  minLines: 1,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Type a message',
                  ),
                )),
                _focus.hasFocus
                    ? Material(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(100),
                        child: InkWell(
                          customBorder: CircleBorder(),
                          radius: 80,
                          onTap: () {
                            // db update here
                            messages
                                .doc(this.chatID)
                                .update({
                                  'messages': FieldValue.arrayUnion([
                                    msgCtrl.text +
                                        "⛄𝄞⛄" +
                                        DateTime.now().toString() +
                                        "⛄𝄞⛄" +
                                        globals.currentUID,
                                  ]),
                                  'status': "sent"
                                })
                                .then((value) => messages
                                    .doc(this.chatID)
                                    .update({'status': 'sent'}))
                                .catchError((error) => print(error));
                            msgCtrl.clear();
                          },
                          splashColor: Colors.redAccent.withOpacity(0.5),
                          highlightColor: Colors.redAccent.withOpacity(0.5),
                          child: Container(
                            width: 42,
                            height: 42,
                            child: Icon(Icons.send_rounded),
                          ),
                        ))
                    : SizedBox.shrink(),
                SizedBox(width: 4)
              ]),
            )),
      ),
    );
  }
}
