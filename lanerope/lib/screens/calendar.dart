import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lanerope/calendar/CalendarBloc.dart';
import 'package:lanerope/calendar/CalendarEvent.dart';
import 'package:lanerope/calendar/CalendarState.dart';
import 'package:lanerope/calendar/EventCreator.dart' as ec2;
import 'package:lanerope/globals.dart' as globals;
import 'package:lanerope/pagesDrawer.dart' as pd;
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

bool ios = Platform.isIOS;
bool android = Platform.isAndroid;

class CalendarThing {
  // i don't wanna use the word event cuz i need it for bloc
  List occurrences;
  String title;
  late Duration length;
  late DateTime begin;

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

  CalendarThing(String duration, DateTime begin, {required this.occurrences, this.title = ''}) {
    this.length = parseDuration(duration);
    this.begin = begin;
  }
}

class Calendar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CalendarState();
  }
}

// keeping this as stateful widget for now because i need mutable fields
// not sure if there's a better way

class _CalendarState extends State<Calendar> {
  late List<dynamic> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  List _getEventsForDay(DateTime day) {
    // puts event dots based on length of list
    DateFormat fm = DateFormat("yyyy-MM-dd");
    String now = fm.format(day);
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ec2.EventCreator('', '', '')));
                      },
                      icon: Icon(Icons.add))
                ]
              : null,
        ),
        floatingActionButton: globals.role == "Coach/Admin"
            ? FloatingActionButton(
                child: const Icon(Icons.date_range),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ec2.EventCreator('', '', '')));
                },
              )
            : null,
        body: BlocProvider(
          create: (context) =>
              CalendarBloc(DateSelected(_getEventsForDay(_focusedDay))),
          lazy: false,
          child:
              BlocBuilder<CalendarBloc, CalendarState>(builder: (_, calState) {
            if (calState is DateSelected) {
              return Column(children: [
                Builder(
                  builder: (context) => TableCalendar(
                    firstDay: DateTime.utc(2020, 9, 1),
                    lastDay: DateTime.utc(2022, 06, 31),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      if (!isSameDay(_selectedDay, selectedDay)) {
                        _focusedDay = focusedDay;
                        _selectedDay = selectedDay;
                        BlocProvider.of<CalendarBloc>(context)
                            .add(SelectDate(_getEventsForDay(selectedDay)));
                      }
                    },
                    calendarFormat: _calendarFormat,
                    onFormatChanged: (format) {
                      print("yote");
                      _calendarFormat = format;
                      BlocProvider.of<CalendarBloc>(context)
                          .add(ChangeFormat(format));
                    },
                    onPageChanged: (focusedDay) {
                      _focusedDay = focusedDay;
                    },
                    eventLoader: (day) {
                      return _getEventsForDay(day);
                    },
                  ),
                ),
                ListView(
                  padding: EdgeInsets.all(8.0),
                  children: calState.todaysEvents,
                  shrinkWrap: true,
                )
              ]);
            } else {
              return Text("This should never appear");
            }
          }),
        ),
        drawer: pd.PagesDrawer().importDrawer(context));
  }
}
