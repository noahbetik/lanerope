import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageView extends StatelessWidget {
  final String convoName;

  MessageView({required this.convoName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(this.convoName)),
      body: ListView(
          children: [] // placeholder, gonna want listview builder later
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
              SizedBox(
                  width: 330,
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 1,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Type a message',
                    ),
                  ))
            ]),
          )),
    );
  }
}
