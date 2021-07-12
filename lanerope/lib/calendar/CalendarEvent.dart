import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/material.dart';

abstract class CalendarEvent {}

class ChangeFormat extends CalendarEvent {
  CalendarFormat ft = CalendarFormat.month;

  ChangeFormat(CalendarFormat newFormat) {
    ft = newFormat;
  }
}

class SelectDate extends CalendarEvent {
  late List todaysEvents;

  SelectDate(List events){
    todaysEvents = events;
  }

}
