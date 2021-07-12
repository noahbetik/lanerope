import 'package:flutter/material.dart';

abstract class CalendarState {}

class DateSelected extends CalendarState {
  List<Widget> todaysEvents = [];

  DateSelected(List events) {
    events.forEach((element) {
      todaysEvents.add(ListTileTheme(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.black26,
            width: 1.0
          ),
          borderRadius: BorderRadius.all(Radius.circular(8.0))
        ),
          child: ListTile(
        title: Text(element.title),
      )));
      todaysEvents.add(SizedBox(height: 8.0));
    });
  }
}

class FormatChanged extends CalendarState {}
