import 'dart:io';

import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Calendar")),
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
        ),
        drawer: pd.PagesDrawer().importDrawer(context));
  }
}
