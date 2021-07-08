import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lanerope/calendar/EventCreator.dart' as ec2;
import 'package:lanerope/globals.dart' as globals;
import 'package:lanerope/pagesDrawer.dart' as pd;
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

bool ios = Platform.isIOS;
bool android = Platform.isAndroid;

class CalendarThing { // i don't wanna use the word event cuz i need it for bloc
  List occurrences;
  String title;
  late Duration length;

  Duration parseDuration(String s) {
    int hours = 0;
    int minutes = 0;
    int micros;
    List<String> parts = s.split(':');
    if (parts.length > 2) {
      hours = int.parse(parts[parts.length - 3]);
    }
    if (parts.length > 1) {
      minutes = int.parse(parts[parts.length - 2]);
    }
    micros = (double.parse(parts[parts.length - 1]) * 1000000).round();
    return Duration(hours: hours, minutes: minutes, microseconds: micros);
  }

  CalendarThing(String duration, {required this.occurrences, this.title = ''}) {
    DateFormat format = DateFormat("yyyy-MM-dd");
    this.length = parseDuration(duration);
  }
}

class Calendar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CalendarState();
  }
}

class _CalendarState extends State<Calendar> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  List _getEventsForDay(DateTime day) {
    // puts event dots based on length of list
    DateFormat fm = DateFormat("yyyy-MM-dd");
    String now = fm.format(day);
    print(now);
    print(globals.events[now]);
    return globals.events[now] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Calendar"),
          actions: globals.role == "Coach/Admin"
              ? [
                  IconButton(
                      onPressed: () {
                        DateTime now = DateTime.now();
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => ec2.EventCreator('', '', '')));
                      },
                      icon: Icon(Icons.add))
                ]
              : null,
        ),
        floatingActionButton: globals.role == "Coach/Admin"
            ? FloatingActionButton(
                child: const Icon(Icons.date_range),
                onPressed: () {
                  DateTime now = DateTime.now();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ec2.EventCreator('', '', '')));
                },
              )
            : null,
        body: TableCalendar(
          firstDay: DateTime.utc(2020, 9, 1),
          lastDay: DateTime.utc(2022, 06, 31),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay; // update `_focusedDay` here as well
            });
          },
          calendarFormat: _calendarFormat,
          onFormatChanged: (format) {
            setState(() {
              _calendarFormat = format;
            });
          },
          onPageChanged: (focusedDay) {
            // No need to call `setState()` here
            _focusedDay = focusedDay;
          },
          eventLoader: (day) {
            return _getEventsForDay(day);
          },
        ),
        drawer: pd.PagesDrawer().importDrawer(context));
  }
}
