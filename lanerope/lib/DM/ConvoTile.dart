import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'MessageView.dart';


class ConvoTile extends StatelessWidget {
  final String name;
  final String lastMsg;
  final String timestamp;

  ConvoTile({this.name = '', this.lastMsg = '', this.timestamp = ''});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(this.name),
      subtitle: Text(this.lastMsg),
      trailing: Text(this.timestamp),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => MessageView()));
      },
      dense: true,
    );
  }

}