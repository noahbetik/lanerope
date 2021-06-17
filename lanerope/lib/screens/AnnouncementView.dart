
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lanerope/DesignChoices.dart' as dc;

class AnnouncementView extends StatelessWidget {
  final String title;
  final String mainText;
  final Image coverImage;
  final String author;
  final String date;
  final EdgeInsets articlePadding = EdgeInsets.all(12.0);

  AnnouncementView(
      this.title, this.mainText, this.coverImage, this.author, this.date);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(children: [
          this.coverImage,
          Container(
              child: Text(title, style: dc.singleAnnouncementTitle),
              padding: articlePadding),
          Container(
              child: Row(children: [
                Text("Posted By: " + author, style: TextStyle(
                  fontFamily: "Oxygen",
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold
                )),
                Text("\t\t\t" + date, style: TextStyle(
                    fontFamily: "Oxygen",
                    fontSize: 14.0,
                    fontWeight: FontWeight.w100
                )),
              ]),
              padding: articlePadding),
          Container(
              child: Text(mainText, style: dc.announcementText),
              padding: articlePadding)
        ]));
  }
}
