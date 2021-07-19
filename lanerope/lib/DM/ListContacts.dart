import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lanerope/DM/ConvoTile.dart';

class ListContacts extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Message")
      ),
      body: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index){
        return ConvoTile(name: "n-dawg number " + (index+1).toString(), lastMsg: "Tap to send a message");
      }),
    );
  }

}