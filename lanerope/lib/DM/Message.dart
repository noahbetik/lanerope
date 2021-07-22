import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum Participant { you, them }
enum MsgStatus { sending, sent, delivered, received, error, old }

extension toString on MsgStatus {
  // feels really dumb but idk what else to do
  String str() {
    switch (this){
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

class Message extends StatefulWidget {
  late final String text;
  late final Participant user;

  Message({required this.text, required this.user});

  @override
  State<StatefulWidget> createState() {
    return MsgState();
  }
}

class MsgState extends State<Message>{

  late MsgStatus status;

  MsgState(){
    status = MsgStatus.sending;
  }

  void updateStatus (MsgStatus newStatus) {
    setState(() {
      status = newStatus;
    });
  }

  Color statusColor = Colors.grey;
  double statusSize = 10.0;

  Widget showStatus() {
    switch (this.status) {
      case MsgStatus.sending:
        return Icon(Icons.send_outlined);
      case MsgStatus.sent:
        return Text("Sent", style: TextStyle(color: statusColor, fontSize: statusSize));
      case MsgStatus.delivered:
        return Text("Delivered", style: TextStyle(color: statusColor, fontSize: statusSize));
      case MsgStatus.received:
        return Text("Read", style: TextStyle(color: statusColor, fontSize: statusSize));
      case MsgStatus.error:
        return Text("Error Sending", style: TextStyle(color: Colors.red, fontSize: statusSize));
      case MsgStatus.old:
        return SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 400,
        width: 300,
        child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
            child: Column(children: [
              Container(
                  decoration: BoxDecoration(
                      color: widget.user == Participant.you
                          ? Colors.lightBlueAccent
                          : Colors.grey[200]),
                  child: Text(widget.text)),
              widget.user == Participant.you ? showStatus() : SizedBox.shrink()
            ])));
  }
}
