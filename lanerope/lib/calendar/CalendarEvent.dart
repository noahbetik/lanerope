import 'package:table_calendar/table_calendar.dart';

abstract class CalendarEvent {}

class ChangeFormat extends CalendarEvent {
  CalendarFormat fmt = CalendarFormat.month;

  ChangeFormat(CalendarFormat newFormat) {
    fmt = newFormat;
  }
}

class SelectDate extends CalendarEvent {
  late List todaysEvents;

  SelectDate(List events){
    todaysEvents = events;
  }

}
