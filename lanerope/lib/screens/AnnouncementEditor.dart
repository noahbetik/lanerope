import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
              decoration: InputDecoration(
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.red,
                    width: 1.0
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.blue,
                      width: 2.0
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.red,
                      width: 2.0
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                hintText: "Title",
                hintStyle: TextStyle(
                  color: Colors.grey
                )
              ),
            ),

            SingleChildScrollView(
              padding: EdgeInsets.zero,
              child: TextFormField(// eventually wanna replace these with app-level theme constants
                scrollPadding: EdgeInsets.zero,
                maxLines: 10, // idk
                controller: mainText,
                decoration: InputDecoration(
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.red,
                          width: 1.0
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.blue,
                          width: 2.0
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.red,
                          width: 2.0
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    hintText: "Title",
                    hintStyle: TextStyle(
                        color: Colors.grey
                    )
                ),
              ),
            )
          ]
        )
      )

    );
  }

}