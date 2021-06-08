import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lanerope/DesignChoices.dart' as dc;

class AnnouncementEditor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final TextEditingController titleText = TextEditingController();
    final TextEditingController mainText = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: Text("Create an Announcement")),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField( // eventually wanna replace these with app-level theme constants
              maxLength: 100, // idk
              controller: titleText,
              decoration: dc.formBorder("Title", '')
            ),
            SingleChildScrollView(
              padding: EdgeInsets.zero,
              child: TextFormField(// eventually wanna replace these with app-level theme constants
                scrollPadding: EdgeInsets.zero,
                maxLines: 10, // idk
                controller: mainText,
                decoration: dc.formBorder('', '')
              ),
            )
          ]
        )
      )

    );
  }

}