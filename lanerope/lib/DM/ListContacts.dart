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
    print(globals.contacts);
    return Scaffold(
      appBar: AppBar(
        title: Text("New Message")
      ),
      body: ListView.builder(
          itemCount: globals.contacts.length,
          itemBuilder: (context, index){
            print(globals.contacts);
        return ConvoTile(name: globals.contacts[index]["name"], lastMsg: "Tap to send a message");
      }),
    );
  }

}