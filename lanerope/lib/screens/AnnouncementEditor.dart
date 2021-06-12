import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lanerope/DesignChoices.dart' as dc;
import 'package:lanerope/screens/home.dart';
import 'package:image_picker/image_picker.dart';

final CollectionReference announcements =
    FirebaseFirestore.instance.collection('announcements');
FirebaseStorage storage = FirebaseStorage.instance;

class AnnouncementEditor extends StatefulWidget {
  @protected
  static int x = 0; // this should be database level
  static DateTime lastUpdate = DateTime.now();
  final String docTitle = DateTime.now().year.toString() +
      "-" +
      DateTime.now().month.toString() +
      "-" +
      DateTime.now().day.toString() +
      "_" +
      x.toString();

  static void dateCheck() {
    if (DateTime.now().difference(lastUpdate) > Duration(hours: 24)) {
      x = 0;
    } else {
      x++;
      print(x);
    }
    lastUpdate = DateTime.now();
    print(x);
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
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
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
    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
            appBar: AppBar(title: Text("Create an Announcement")),
            body: Container(
                padding: EdgeInsets.all(8.0),
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
                            height: 200, // arbitrary for now
                            width: 200,
                            child: Image.file(image, fit: BoxFit.cover))
                        : Text('No image selected'),
                  ]),
                  Spacer(),
                  ElevatedButton(
                      onPressed: () async {
                        announcements.doc(widget.docTitle).set(
                          {
                            "header_image": null,
                            "title_text": titleText.text,
                            "main_text": mainText.text
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
                        await saveImage(image, widget.docTitle);
                        print("image uploaded");
                        announcementList.add(Announcement(
                            titleText.text, mainText.text, Image.file(image, fit: BoxFit.cover)));
                        print("announcement added");
                        AnnouncementEditor.dateCheck();
                        print("some behind the scenes magic");
                        ctrl.add(true);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Text("Publish"))
                ]))));
  }
}
