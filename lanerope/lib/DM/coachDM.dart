import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lanerope/DM/MessageView.dart';
import 'package:lanerope/DM/ListContacts.dart';
import 'package:lanerope/pagesDrawer.dart' as pd;

bool ios = Platform.isIOS;
bool android = Platform.isAndroid;

List conversations = [];

class CoachDM extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Direct Messages")),
      body: ListView.builder(
          itemCount: conversations.length,
          itemBuilder: (context, index){
            return conversations[index];
          }),
      drawer: pd.PagesDrawer().importDrawer(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ListContacts()));
        }
      ),
    );
  }
}
