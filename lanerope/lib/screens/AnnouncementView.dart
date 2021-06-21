
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lanerope/DesignChoices.dart' as dc;

class AnnouncementView extends StatelessWidget {
  final String title;
  final String mainText;
  final Image? coverImage;
  final String author;
  final String date;
  final EdgeInsets articlePadding = EdgeInsets.all(12.0);

  AnnouncementView(
      this.title, this.mainText, this.author, this.date, {this.coverImage});

  List<Widget> articleGen() {
    List<Widget> widgets = [];
    if (coverImage != null){
      widgets.add(coverImage!);
    }
    widgets.add(Container(
        child: Text(title, style: dc.singleAnnouncementTitle),
        padding: articlePadding));
    widgets.add(Container(
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
        padding: articlePadding));
    widgets.add(Container(
        child: Text(mainText, style: dc.announcementText),
        padding: articlePadding));
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(children: articleGen()));
  }
}
