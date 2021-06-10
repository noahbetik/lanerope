import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lanerope/DesignChoices.dart' as dc;
import 'package:lanerope/screens/home.dart';

class AnnouncementEditor extends StatelessWidget {

  final TextEditingController titleText = TextEditingController();
  final TextEditingController mainText = TextEditingController();

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
                  ElevatedButton(
                    onPressed: () {
                      announcementList.add(Announcement(titleText.text, mainText.text));
                      ctrl.add(true);
                      Navigator.pop(context);
                    },
                    child: Text("Publish")
                  )
                ]))));
  }
}
