import 'package:flutter/material.dart';

abstract class CalendarState {}

class DateSelected extends CalendarState{
  List<Widget> todaysEvents = [];

  DateSelected(List events) {
    events.forEach((element) {
      todaysEvents.add(ListTile(
        title: Text(element.title),
      ));
    });
  }

}

class FormatChanged extends CalendarState{

}