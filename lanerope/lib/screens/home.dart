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
  final int perPage = 20;

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
          } else {
            List<DocumentSnapshot> qs = snapshot.data!.docs.reversed.toList();
            for (DocumentSnapshot ds in qs) {
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
                globals.announcementList.add(Announcement(
                    result["title"],
                    result["text"],
                    result["author"],
                    result["date"],
                    result["id"],
                    ds.id,
                    coverImage: Image(
                      image: result["image"],
                      fit: BoxFit.cover,
                    )));
              } else {
                globals.announcementList.add(Announcement(
                    result["title"],
                    result["text"],
                    result["author"],
                    result["date"],
                    result["id"],
                    ds.id));
              }
            }
            globals.announcementList
                .add(PageSelector(maxPages: 4));
                // (qs.length / perPage).ceil()
          }

          return Scaffold(
              appBar: dc.bar("Lanerope"),
              //backgroundColor: Colors.white,
              floatingActionButton:
                  globals.role == "Coach/Admin" ? CreateAnnouncement() : null,
              body:
                  ListView(reverse: false, children: globals.announcementList),
              drawer: pd.PagesDrawer().importDrawer(context));
        });
  }
}

class PageSelector extends StatefulWidget {
  final int maxPages;

  PageSelector({required this.maxPages});

  @override
  State<StatefulWidget> createState() {
    return PageSelectorState();
  }
}

class PageSelectorState extends State<PageSelector>
    with AutomaticKeepAliveClientMixin {
  Widget left() {
    Widget item = pageNo <= 1
        ? Icon(Icons.navigate_before_rounded, color: Colors.grey)
        : IconButton(
            onPressed: () {
              setState(() {
                pageNo--;
              });
            },
            icon: Icon(Icons.navigate_before_rounded),
          );
    return item;
  }

  Widget right() {
    Widget item = pageNo >= widget.maxPages
        ? Icon(Icons.navigate_next_rounded, color: Colors.grey)
        : IconButton(
            onPressed: () {
              setState(() {
                pageNo++;
              });
            },
            icon: Icon(Icons.navigate_next_rounded),
          );
    return item;
  }

  int pageNo = 1;

  Widget display() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      left(),
      Text("Page " + pageNo.toString(), textAlign: TextAlign.center,),
      right()
    ]);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return display();
  }

  @override
  bool get wantKeepAlive => true;
}

class Announcement extends StatefulWidget {
  // wanna make it look like the athletic-ish
  // is there a way to send keep-alive noti without using the state mixin?
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
  State<StatefulWidget> createState() {
    return AnnouncementState();
  }
}

class AnnouncementState extends State<Announcement>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    Widget titleHeader = widget.coverImage != null
        ? Container(
            height: 200, // arbitrary for now
            width: double.infinity,
            child: Stack(children: [
              Container(
                  width: double.infinity,
                  child: ColorFiltered(
                      child: widget.coverImage,
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.4), BlendMode.darken))),
              Container(
                child: Text(widget.title,
                    style: dc.announcementTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                alignment: Alignment.bottomLeft,
                padding: EdgeInsets.all(8.0),
              )
            ]))
        : Container(
            child: Text(widget.title,
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
                      widget.mainText,
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
                                                          widget.title,
                                                          widget.mainText,
                                                          widget.author,
                                                          widget.date,
                                                          coverImage: widget
                                                              .coverImage)));
                                        },
                                        child: Text("VIEW FULL")),
                                    IconButton(
                                        onPressed: () {
                                          print("editing " + widget.dbTitle);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AnnouncementEditor(
                                                          givenTitle:
                                                              widget.title,
                                                          givenText:
                                                              widget.mainText,
                                                          db: widget.dbTitle)));
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
                                                          widget.title,
                                                          widget.mainText,
                                                          widget.author,
                                                          widget.date,
                                                          coverImage: widget
                                                              .coverImage)));
                                        },
                                        child: Text("VIEW FULL"))
                                  ]))
                  ]))
            ])));
  }

  @override
  bool get wantKeepAlive => true;
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
