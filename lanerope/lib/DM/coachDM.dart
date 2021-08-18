import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lanerope/DM/ListContacts.dart';
import 'package:lanerope/globals.dart' as globals;
import 'package:lanerope/pagesDrawer.dart' as pd;

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
      // streambuilder monitors all conversations to provide realtime update from outside the convo view
      // rebuilds each convo tile
      body: StreamBuilder<QuerySnapshot>(
          stream: messages.snapshots(),
          builder: (context, snap) {
            if (!snap.hasData) {
              return SizedBox.shrink();
            } else {
              // seems weird since this is only used for first view
              return ListView.builder(
                  itemCount: globals.convos.length,
                  itemBuilder: (context, index) {
                    return globals.convos[index];
                  });
            }
          }),
      drawer: pd.PagesDrawer().importDrawer(context),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.message),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ListContacts()));
          }),
    );
  }
}
