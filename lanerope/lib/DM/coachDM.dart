import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lanerope/DM/ConvoTile.dart';
import 'package:lanerope/DM/MessageView.dart';
import 'package:lanerope/DM/ListContacts.dart';
import 'package:lanerope/pagesDrawer.dart' as pd;
import 'package:lanerope/globals.dart' as globals;

bool ios = Platform.isIOS;
bool android = Platform.isAndroid;
final CollectionReference messages =
FirebaseFirestore.instance.collection('messages');

List conversations = [];

class CoachDM extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Direct Messages")),
      body: ListView.builder(
          itemCount: globals.convos.length,
          itemBuilder: (context, index) {
            return globals.convos[index];
          }),
      drawer: pd.PagesDrawer().importDrawer(context),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.message),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ListContacts()));
          }
      ),
    );
  }
}
