import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lanerope/globals.dart' as globals;
import 'package:lanerope/pagesDrawer.dart' as pd;
import 'package:lanerope/screens/AnnouncementEditor.dart';
import 'package:lanerope/DesignChoices.dart' as dc;
import 'package:lanerope/screens/AnnouncementView.dart';
import 'package:image_picker/image_picker.dart';

bool ios = Platform.isIOS;
bool android = Platform.isAndroid;
FirebaseAuth auth = FirebaseAuth.instance;
final CollectionReference users =
    FirebaseFirestore.instance.collection('users');
final CollectionReference announcements =
    FirebaseFirestore.instance.collection('announcements');

StreamController<bool> ctrl = StreamController<bool>.broadcast();
Stream<bool> redraw = ctrl.stream; // maybe wanna make this global some day

String sayHi() {
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
  return hello + "\nYou are a " + globals.role;
}

List<Widget> announcementList = [];

Future<List<dynamic>> _getAnnouncement(String docTitle) async {
  DocumentSnapshot snap = await announcements.doc(docTitle).get();
  String title = await snap.get("title_text");
  String text = await snap.get("main_text");
  String imgURL = await snap.get("header_image");
  Image img = Image.network(imgURL, fit: BoxFit.cover);
  return [title, text, img];
}

Future<void> allAnnouncements() async { // it still feels stupid to do it this way but whatever
  announcementList.clear();
  announcementList.add(Text(sayHi(),
      textDirection: TextDirection.ltr,
      style: TextStyle(color: Colors.black, fontSize: 36.0)));

  announcements.get().then((snapshot) {
    snapshot.docs.forEach((element) async {
      List<dynamic> info = await _getAnnouncement(element.id);
      announcementList.add(Announcement(info[0], info[1], info[2]));
    });
  });
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([allAnnouncements()]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return StreamBuilder<bool>(
                stream: redraw,
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  ctrl.add(true);
                  return Scaffold(
                      appBar: AppBar(title: Text("Lanerope")),
                      floatingActionButton: globals.role == "Coach/Admin"
                          ? CreateAnnouncement()
                          : null,
                      body: ListView.builder(
                        padding: EdgeInsets.all(8.0),
                        itemCount: announcementList.length,
                        itemBuilder: (context, index) {
                          return announcementList[index];
                        },
                      ),
                      drawer: pd.PagesDrawer().importDrawer(context));
                });
          } else {
            return Scaffold(
                appBar: AppBar(title: Text("Lanerope")),
                floatingActionButton:
                    globals.role == "Coach/Admin" ? CreateAnnouncement() : null,
                body: Center(child: CircularProgressIndicator.adaptive()),
                drawer: pd.PagesDrawer().importDrawer(context));
          }
        });
  }
}

class Announcement extends StatelessWidget {
  // wanna make it look like the athletic-ish
  final String title;
  final String mainText;
  final Image coverImage;

  Announcement(this.title, this.mainText, this.coverImage);

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Column(children: [
              Container(
                  height: 200, // arbitrary for now
                  width: double.infinity,
                  child: Stack(children: [
                    Container(
                        width: double.infinity,
                        child: ColorFiltered(
                            child: this.coverImage,
                            colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.4),
                                BlendMode.darken))),
                    Container(
                      child: Text(this.title, style: dc.announcementTitle),
                      alignment: Alignment.bottomLeft,
                      padding: EdgeInsets.all(8.0),
                    )
                  ])),
              Container(
                  // should be less for landscape
                  padding: EdgeInsets.all(8.0),
                  child: Column(children: [
                    Text("the subtitle is optional perhaps",
                        style: Theme.of(context).textTheme.subtitle1),
                    Text(
                      this.mainText,
                      textDirection: TextDirection.ltr,
                      overflow: TextOverflow.fade,
                      style: dc.announcementText,
                      maxLines: 20,
                    ),
                    Container(
                        alignment: Alignment.bottomLeft,
                        child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AnnouncementView(
                                          this.title,
                                          this.mainText,
                                          this.coverImage)));
                            },
                            child: Text("VIEW FULL")))
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
