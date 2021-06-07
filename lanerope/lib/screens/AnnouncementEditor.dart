import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnnouncementEditor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final TextEditingController title = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: Text("Create an Announcement")),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              controller: title,
              decoration: InputDecoration(
                hintText: "Title",
                hintStyle: TextStyle(
                  color: Colors.grey
                )
              ),
            )
          ]
        )
      )

    );
  }

}