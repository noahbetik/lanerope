import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lanerope/DesignChoices.dart' as dc;

class AnnouncementView extends StatelessWidget {
  final String title;
  final String mainText;
  final Image coverImage;
  final String author;
  final String date;

  AnnouncementView(
      this.title, this.mainText, this.coverImage, this.author, this.date);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Lanerope"),
        ),
        body: ListView(children: [
          this.coverImage,
          Container(
              child: Text(title, style: dc.singleAnnouncementTitle),
              padding: EdgeInsets.all(8.0)),
          Container(
              child: Row(children: [
                Text(author, style: dc.announcementText),
                Text(date, style: dc.announcementText),
              ]),
              padding: EdgeInsets.all(8.0)),
          Container(
              child: Text(mainText, style: dc.announcementText),
              padding: EdgeInsets.all(8.0))
        ]));
  }
}
