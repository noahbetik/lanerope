import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lanerope/DM/ConvoTile.dart';
import 'package:lanerope/globals.dart' as globals;

final CollectionReference users =
    FirebaseFirestore.instance.collection('users');

class ListContacts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("New Message")),
      body: ListView.builder(
          itemCount: globals.contacts.length,
          itemBuilder: (context, index) {
            return ConvoTile(
                id: globals.contacts[index]["id"],
                name: globals.contacts[index]["name"],
                newMsg: false,
                lastMsg: "Tap to send a message");
          }),
    );
  }
}
