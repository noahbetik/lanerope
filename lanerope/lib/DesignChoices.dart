import 'package:flutter/material.dart';

InputDecoration formBorder(String hint, String helper) {
  return new InputDecoration(
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.lightBlue, width: 2.0),
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
  appBarTheme: AppBarTheme(
    elevation: 0
  ),
  scaffoldBackgroundColor: Colors.white,
  accentColor: Colors.lightBlueAccent,
  buttonColor: Colors.redAccent,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      primary: Colors.lightBlue
    )
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.redAccent,
  ),
  fontFamily: 'Oxygen',
  iconTheme: IconThemeData(
    color: Colors.black87
  ),
  cardTheme: CardTheme(
    color: Colors.white,
    elevation: 2.0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    margin: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0, top: 2.0),
  )
);

TextStyle announcementTitle = new TextStyle(
  color: Colors.white,
  fontSize: 36.0,
);

TextStyle noImgTitle = new TextStyle(
  color: Colors.black,
  fontSize: 36.0,
);

TextStyle singleAnnouncementTitle = new TextStyle(
  color: Colors.black,
  fontSize: 36.0,
);

TextStyle announcementText = new TextStyle(color: Colors.black, fontSize: 16.0);
