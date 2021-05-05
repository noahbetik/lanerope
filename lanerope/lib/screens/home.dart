import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      return Material(
        color: Colors.white,
        child: Center(
            child: Text(sayHi(),
                textDirection: TextDirection.ltr,
                style: TextStyle(color: Colors.black, fontSize: 36.0))),
      );
  }

  String sayHi() {
    String hello;
    DateTime now = new DateTime.now();
    int hour = now.hour;
    int minute = now.minute;
    if (hour < 12){
      hello = "good morning dawg";
    }
    else if (hour < 18){
      hello = "good afternoon dawg";
    }
    else{
      hello = "good evening dawg";
    }

    String minutes = (minute < 10) ? "0" + minute.toString() : minute.toString();

    return "The time is " + hour.toString() + ":" + minutes + "\n" + hello;
  }
}
