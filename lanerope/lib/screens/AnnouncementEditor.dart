import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lanerope/DesignChoices.dart' as dc;
import 'package:lanerope/globals.dart' as globals;
import 'package:lanerope/screens/home.dart';
import 'package:path/path.dart' as path;

final CollectionReference announcements =
    FirebaseFirestore.instance.collection('announcements');
FirebaseStorage storage = FirebaseStorage.instance;

class AnnouncementEditor extends StatefulWidget {
  static Future<String> getTitle() async {
    int id = await globals.announcementID();

    DateTime now = DateTime.now();
    String docTitle = now.year.toString() +
        "-" +
        now.month.toString() +
        "-" +
        now.day.toString() +
        "_" +
        id.toString();
    return docTitle;
  }

  @override
  State<StatefulWidget> createState() {
    return EditorState();
  }
}

class EditorState extends State<AnnouncementEditor> {
  final titleText = TextEditingController();
  final mainText = TextEditingController();
  final picker = ImagePicker();
  var image;

  Future getImage() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 25);
    final croppedFile = await ImageCropper.cropImage(sourcePath: pickedFile!.path, aspectRatio: CropAspectRatio(ratioX: 4, ratioY: 3));

    setState(() {
      if (croppedFile != null) {
        image = croppedFile;
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> saveImage(File images, String document) async {
    String imageURL = await uploadFile(image);
    announcements.doc(document).update({"header_image": imageURL});
  }

  Future<String> uploadFile(File image) async {
    final String fileName = path.basename(image.path);
    File imageFile = File(image.path);
    await storage
        .ref(fileName)
        .putFile(imageFile, SettableMetadata(customMetadata: {}));
    String downloadURL = await storage.ref(fileName).getDownloadURL();
    return downloadURL;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // maybe put gesture detector bck here once it's better under control
        appBar: AppBar(title: Text("Create an Announcement")),
        body: Container(
            padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
            child: SingleChildScrollView(
                child: Column(children: [
              TextField(
                  // eventually wanna replace these with app-level theme constants
                  maxLength: 100, // idk
                  controller: titleText,
                  decoration: dc.formBorder("Title", '')),
              SingleChildScrollView(
                padding: EdgeInsets.zero,
                child: TextFormField(
                    scrollPadding: EdgeInsets.zero,
                    maxLines: 10,
                    // idk
                    controller: mainText,
                    keyboardType: TextInputType.multiline,
                    decoration: dc.formBorder('Announcement Text', '')),
              ),
              Container(
                  alignment: Alignment.bottomLeft,
                  child: TextButton(
                      onPressed: getImage, child: Text("ADD IMAGE"))),
              Column(children: [
                Text('Selected Cover Image'),
                image != null
                    ? Container(
                        height: 150, // arbitrary for now
                        width: 200,
                        child: Image.file(image, fit: BoxFit.cover))
                    : Text('No image selected'),
              ]),
              //Spacer(),
              ElevatedButton(
                  onPressed: () async {
                    DateTime now = DateTime.now();
                    String pubDate =
                        DateFormat.yMd().format(now) +
                            " - " +
                            DateFormat.Hm().format(now);
                    String dbTitle = await AnnouncementEditor.getTitle();
                    int startIndex = dbTitle.indexOf('_') + 1;
                    announcements.doc(dbTitle).set(
                      {
                        "header_image": null,
                        "title_text": titleText.text,
                        "main_text": mainText.text,
                        "author": globals.fullName,
                        "date": pubDate,
                        "id": int.parse(dbTitle.substring(startIndex))
                      },
                    );
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                                // not ideal
                                content: Center(
                              child: CircularProgressIndicator.adaptive(),
                              widthFactor: 1,
                              heightFactor: 1,
                            )));
                    await saveImage(image, dbTitle);
                    //await allAnnouncements();
                    print("image uploaded");
                    globals.announcementList.insert(
                        0,
                        Announcement(
                            titleText.text,
                            mainText.text,
                            Image.file(image, fit: BoxFit.cover),
                            globals.fullName,
                            pubDate,
                            int.parse(dbTitle.substring(startIndex))));
                    print("announcement added");
                    globals.complete.add(true);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text("Publish"))
            ]))));
  }
}
