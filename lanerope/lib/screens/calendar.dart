import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lanerope/calendar/EventCreator.dart' as ec2;
import 'package:lanerope/globals.dart' as globals;
import 'package:lanerope/pagesDrawer.dart' as pd;
import 'package:table_calendar/table_calendar.dart';

bool ios = Platform.isIOS;
bool android = Platform.isAndroid;

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
    return globals.events[day] ?? [];
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
                        DateTime oneHour = now.add(Duration(hours: 1));
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
                  DateTime oneHour = now.add(Duration(hours: 1));
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
