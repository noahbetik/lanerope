import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lanerope/DesignChoices.dart' as dc;

class AnnouncementView extends StatelessWidget {

  final String title;
  final String mainText;
  final File coverImage;

  AnnouncementView(this.title, this.mainText, this.coverImage);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lanerope"),),
      body: Container(
        child: Column(
          children: [
            Image.file(this.coverImage),
            Text(title, style: dc.announcementTitle),
            Text(mainText, style: dc.announcementText)
          ]
        )
      )
    );
  }

}