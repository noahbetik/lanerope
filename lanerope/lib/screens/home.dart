import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lanerope/DesignChoices.dart' as dc;
import 'package:lanerope/globals.dart' as globals;
import 'package:lanerope/pagesDrawer.dart' as pd;
import 'package:lanerope/screens/AnnouncementEditor.dart';
import 'package:lanerope/screens/AnnouncementView.dart';

bool ios = Platform.isIOS;
bool android = Platform.isAndroid;
FirebaseAuth auth = FirebaseAuth.instance;
final CollectionReference users =
    FirebaseFirestore.instance.collection('users');
final CollectionReference announcements =
    FirebaseFirestore.instance.collection('announcements');

StreamController<bool> ctrl = StreamController<bool>.broadcast();
Stream<bool> redraw = ctrl.stream; // maybe wanna make this global some day

List<Widget> sayHi() {
  String hello;
  DateTime now = new DateTime.now();
  int hour = now.hour;
  if (globals.name == '') {
    globals.findRole();
  }
  String name = globals.name;
  if (hour < 12) {
    hello = "good morning " + name;
  } else if (hour < 18) {
    hello = "good afternoon " + name;
  } else {
    hello = "good evening " + name;
  }
  return [Text(hello + "\nYou are a " + globals.role)];
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // redo with firestore stream
    return StreamBuilder<QuerySnapshot>(
        stream: announcements.snapshots(),
        builder: (BuildContext context, snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(
                appBar: dc.bar("Lanerope"),
                floatingActionButton:
                globals.role == "Coach/Admin" ? CreateAnnouncement() : null,
                body: Center(child: CircularProgressIndicator.adaptive()),
                drawer: pd.PagesDrawer().importDrawer(context));
          }
          else{
            List<DocumentSnapshot> qs = snapshot.data!.docs.reversed.toList();
            for(DocumentSnapshot ds in qs){
              String title = ds.get("title_text");
              String text = ds.get("main_text");
              String imgURL = ds.get("header_image");
              String author = ds.get("author");
              String date = ds.get("date");
              int id = ds.get("id");
              Map result = {
                "title": title,
                "text": text,
                "author": author,
                "date": date,
                "id": id
              };
              if (imgURL != '') {
                result["image"] = CachedNetworkImageProvider(imgURL);
                //Image.network(imgURL, fit: BoxFit.cover);
              }
              if (result.containsKey("image")) {
                globals.announcementList.add(Announcement(result["title"], result["text"],
                    result["author"], result["date"], result["id"], ds.id,
                    coverImage: Image(image: result["image"], fit: BoxFit.cover,)));
              } else {
                globals.announcementList.add(Announcement(result["title"], result["text"],
                    result["author"], result["date"], result["id"], ds.id));
              }
            }
          }

          return Scaffold(
              appBar: dc.bar("Lanerope"),
              //backgroundColor: Colors.white,
              floatingActionButton:
              globals.role == "Coach/Admin" ? CreateAnnouncement() : null,
              body: ListView(
                reverse: false,
                  children: globals.announcementList),
              drawer: pd.PagesDrawer().importDrawer(context));
        });
  }
}


class Announcement extends StatelessWidget {
  // wanna make it look like the athletic-ish
  final String title;
  final String mainText;
  final String author;
  final String date;
  final Image? coverImage;
  final int id;
  final String dbTitle;

  Announcement(
      this.title, this.mainText, this.author, this.date, this.id, this.dbTitle,
      {this.coverImage});

  @override
  Widget build(BuildContext context) {
    Widget titleHeader = this.coverImage != null
        ? Container(
            height: 200, // arbitrary for now
            width: double.infinity,
            child: Stack(children: [
              Container(
                  width: double.infinity,
                  child: ColorFiltered(
                      child: this.coverImage,
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.4), BlendMode.darken))),
              Container(
                child: Text(this.title,
                    style: dc.announcementTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                alignment: Alignment.bottomLeft,
                padding: EdgeInsets.all(8.0),
              )
            ]))
        : Container(
            child: Text(this.title,
                style: dc.noImgTitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
            alignment: Alignment.bottomLeft,
            padding: EdgeInsets.only(left: 8.0, right: 8.0),
          );

    return Card(
        child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Column(children: [
              titleHeader,
              Container(
                  // should be less for landscape
                  padding: EdgeInsets.all(8.0),
                  width: double.infinity,
                  child: Column(children: [
                    Text(
                      this.mainText,
                      textDirection: TextDirection.ltr,
                      overflow: TextOverflow.fade,
                      style: dc.announcementText,
                      maxLines: 10,
                    ),
                    Container(
                        alignment: Alignment.bottomLeft,
                        child: Row(
                            children: globals.role == 'Coach/Admin'
                                ? [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AnnouncementView(
                                                          this.title,
                                                          this.mainText,
                                                          this.author,
                                                          this.date,
                                                          coverImage: this
                                                              .coverImage)));
                                        },
                                        child: Text("VIEW FULL")),
                                    IconButton(
                                        onPressed: () {
                                          print("editing " + this.dbTitle);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AnnouncementEditor(
                                                          givenTitle:
                                                              this.title,
                                                          givenText:
                                                              this.mainText,
                                                          db: this.dbTitle)));
                                        },
                                        icon: const Icon(Icons.edit))
                                  ]
                                : [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AnnouncementView(
                                                          this.title,
                                                          this.mainText,
                                                          this.author,
                                                          this.date,
                                                          coverImage: this
                                                              .coverImage)));
                                        },
                                        child: Text("VIEW FULL"))
                                  ]))
                  ]))
            ])));
  }
}

class CreateAnnouncement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        backgroundColor: Colors.redAccent,
        child: const Icon(Icons.note_add_rounded),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AnnouncementEditor()),
          );
        });
  }
}
