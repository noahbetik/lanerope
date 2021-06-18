import 'package:flutter/material.dart';

InputDecoration formBorder(String hint, String helper) {
  return new InputDecoration(
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue, width: 2.0),
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 2.0),
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      hintText: hint == '' ? null : hint,
      hintStyle: TextStyle(color: Colors.grey),
      helperText: helper == '' ? null : helper);
}

AppBar bar(String title) {
  return AppBar(
    title: Text(title),
    elevation: 0,
  );
}

ThemeData appTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.white,
  accentColor: Colors.lightBlueAccent,
  buttonColor: Colors.redAccent,
  fontFamily: 'Oxygen',
);

TextStyle announcementTitle = new TextStyle(
  color: Colors.white,
  fontSize: 36.0,
);

TextStyle singleAnnouncementTitle = new TextStyle(
  color: Colors.black,
  fontSize: 36.0,
);

TextStyle announcementText = new TextStyle(color: Colors.black, fontSize: 16.0);
