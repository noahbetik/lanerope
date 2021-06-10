import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lanerope/DesignChoices.dart' as dc;
import 'package:lanerope/screens/home.dart';
import 'package:image_picker/image_picker.dart';

class AnnouncementEditor extends StatefulWidget {
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
                  TextFormField(
                      // eventually wanna replace these with app-level theme constants
                      maxLength: 100, // idk
                      controller: titleText,
                      decoration: dc.formBorder("Title", '')),
                  SingleChildScrollView(
                    padding: EdgeInsets.zero,
                    child: TextFormField(
                        scrollPadding: EdgeInsets.zero,
                        maxLines: 10, // idk
                        controller: mainText,
                        decoration: dc.formBorder('Announcement Text', '')),
                  ),
                  Container(
                      alignment: Alignment.bottomLeft,
                      child: TextButton(
                          onPressed: getImage, child: Text("ADD IMAGE"))),
                  Column(children: [
                    Text('Selected Cover Image'),
                    image != null ? Container(
                        height: 200, // arbitrary for now
                        width: 200,
                        child: Image.file(image, fit: BoxFit.cover)) : Text('No image selected'),
                  ]),
                  Spacer(),
                  ElevatedButton(
                      onPressed: () {
                        announcementList
                            .add(Announcement(titleText.text, mainText.text, image));
                        ctrl.add(true);
                        Navigator.pop(context);
                      },
                      child: Text("Publish"))
                ]))));
  }
}
