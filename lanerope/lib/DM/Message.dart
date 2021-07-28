import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum Participant { you, them }
enum MsgStatus { sending, sent, delivered, received, error, old }

final CollectionReference messages =
    FirebaseFirestore.instance.collection('messages');

extension toString on MsgStatus {
  // feels really dumb but idk what else to do
  String str() {
    switch (this) {
      case MsgStatus.sending:
        return "sending";
      case MsgStatus.sent:
        return "sent";
      case MsgStatus.delivered:
        return "delivered";
      case MsgStatus.received:
        return "received";
      case MsgStatus.error:
        return "error";
      case MsgStatus.old:
        return "old";
    }
  }
}

MsgStatus parseString(String dbString) {
  switch (dbString) {
    case "sending":
      return MsgStatus.sending;
    case "sent":
      return MsgStatus.sent;
    case "delivered":
      return MsgStatus.delivered;
    case "received":
      return MsgStatus.received;
    case "error":
      return MsgStatus.error;
    case "old":
      return MsgStatus.old;
    default:
      return MsgStatus.old;
  }
}

class Message extends StatefulWidget {
  final String text;
  final Participant user;
  final String chatID;
  final String timestamp;

  Message(
      {required this.text,
      required this.user,
      required this.chatID,
      required this.timestamp});

  @override
  State<StatefulWidget> createState() {
    return MsgState();
  }
}

class MsgState extends State<Message> {
  late MsgStatus _status;

  MsgState() {
    _status = MsgStatus.sending;
  }

  void updateStatus(MsgStatus newStatus) {
    _status = newStatus;
  }

  Color statusColor = Colors.grey;
  double statusSize = 14.0;

  Widget showStatus(AsyncSnapshot<DocumentSnapshot<Object?>> snap) {
    if (!snap.hasData) {
      return Icon(Icons.send_outlined, size: 14.0, color: Colors.grey);
    } else {
      var ds = snap.data;
      int len = ds!['messages'].length;
      String bit = ds['messages'][len - 1].split("⛄𝄞⛄")[1];
      if (bit != widget.timestamp) {
        updateStatus(MsgStatus.old);
      } else {
        updateStatus(parseString(ds['status']));
      }
      switch (this._status) {
        case MsgStatus.sending:
          return Icon(Icons.send_outlined, size: 14.0, color: Colors.grey);
        case MsgStatus.sent:
          return Text("Sent",
              style: TextStyle(color: statusColor, fontSize: statusSize));
        case MsgStatus.delivered:
          return Text("Delivered",
              style: TextStyle(color: statusColor, fontSize: statusSize));
        case MsgStatus.received:
          return Text("Read",
              style: TextStyle(color: statusColor, fontSize: statusSize));
        case MsgStatus.error:
          return Text("Error Sending",
              style: TextStyle(color: Colors.red, fontSize: statusSize));
        case MsgStatus.old:
          return SizedBox.shrink();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: messages.doc(widget.chatID).snapshots(),
        builder: (context, snap) {
          return Align(
            alignment: widget.user == Participant.you
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Container(
                padding:
                EdgeInsets.only(top: 8.0, bottom: 4.0, left: 8.0, right: 8.0),
                constraints: BoxConstraints(maxWidth: 300),
                child: Column(
                  crossAxisAlignment: widget.user == Participant.you
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            color: widget.user == Participant.you
                                ? Colors.lightBlueAccent
                                : Colors.grey[200]),
                        child: Text(widget.text,
                            style: TextStyle(
                                color: widget.user == Participant.you
                                    ? Colors.white
                                    : Colors.black))),
                    Container(
                        padding: EdgeInsets.only(right: 8.0),
                        child: widget.user == Participant.you
                            ? showStatus(snap)
                            : SizedBox.shrink(),
                        alignment: Alignment.bottomRight)
                  ],
                ))
          );

          /*return Container(
              padding: widget.user == Participant.you
                  ? EdgeInsets.only(
                      top: 8.0, bottom: 4.0, right: 8.0, left: 64.0)
                  : EdgeInsets.only(
                      top: 8.0, bottom: 4.0, right: 64.0, left: 8.0),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(4.0)),
              child: Row(
                  mainAxisSize: MainAxisSize.min,
                  textDirection: widget.user == Participant.you
                      ? TextDirection.ltr
                      : TextDirection.rtl,
                  children: [
                    Spacer(),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                              padding: EdgeInsets.all(8.0),
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.0),
                                  color: widget.user == Participant.you
                                      ? Colors.lightBlueAccent
                                      : Colors.grey[200]),
                              child: Text(widget.text,
                                  textWidthBasis: TextWidthBasis.longestLine,
                                  style: TextStyle(
                                      color: widget.user == Participant.you
                                          ? Colors.white
                                          : Colors.black))),
                          Container(
                              padding: EdgeInsets.only(right: 8.0),
                              child: widget.user == Participant.you
                                  ? showStatus(snap)
                                  : SizedBox.shrink(),
                              alignment: Alignment.bottomRight)
                        ])
                  ]));*/
        });
  }
}
