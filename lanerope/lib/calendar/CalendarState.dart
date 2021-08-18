import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../main.dart';

abstract class CalendarState {}

class DateSelected extends CalendarState {
  List<Widget> todaysEvents = [];

  DateSelected(List events) {
    // element is a CalendarThing
    events.forEach((element) {
      // list of events shown below calendar when date tapped
      todaysEvents.add(ListTileTheme(
          shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black26, width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          child: ListTile(
              title: Text(element.title),
              onTap: () {
                showDialog(
                    context: navigatorKey.currentContext!,
                    // uses global navigation key, seems a little wizardy
                    builder: (context) =>
                        AlertDialog(
                          // could put option to edit here
                          title: Text(element.title),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Event Start: " + DateFormat.Hm().format(element.begin)),
                            Text("Event End: " + DateFormat.Hm().format(element.begin.add(element.length))),
                          ]
                        ),
                        ));
              })));
      todaysEvents.add(SizedBox(height: 8.0));
    });
  }
}

class FormatChanged extends CalendarState {
}
