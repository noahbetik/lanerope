import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lanerope/DesignChoices.dart' as dc;
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:lanerope/InputChipField.dart';

final CollectionReference calendar =
    FirebaseFirestore.instance.collection('calendar');

class EventCreator extends StatefulWidget {
  final String givenTitle;
  final DateTime givenStart;
  final DateTime givenEnd;

  EventCreator(this.givenTitle, this.givenStart, this.givenEnd);

  @override
  State<StatefulWidget> createState() {
    if (givenTitle != '') {
      return _EventCreatorState(
          givenTitle: givenTitle,
          givenStart: givenStart.toString(),
          givenEnd: givenEnd.toString());
    }
    return _EventCreatorState();
  }
}

class _EventCreatorState extends State<EventCreator> {
  late TextEditingController startController;
  late TextEditingController endController;
  late TextEditingController titleText;
  final String givenTitle;
  final String givenStart;
  final String givenEnd;
  final format = DateFormat("yyyy-MM-dd HH:mm");
  List<Widget> mainSpace = [];

  _EventCreatorState(
      {this.givenTitle = '', this.givenStart = '', this.givenEnd = ''}) {
    titleText = TextEditingController(text: givenTitle);
    startController = TextEditingController(text: givenStart);
    endController = TextEditingController(text: givenEnd);
  }

  @override
  void dispose() {
    // to be used later?? idk where
    titleText.dispose();
    startController.dispose();
    endController.dispose();
    super.dispose();
  }

  List<Widget> allocator() {
    print("redefining space");
    if (inSearch == true) {
      return [
        TextFormField(
            maxLength: 100, // idk
            controller: titleText,
            decoration: dc.formBorder("Event Title", '')),
        SizedBox(height: 8),
        InputChipField(),
        buildList()
      ];
    } else {
      return [
        TextFormField(
            maxLength: 100, // idk
            controller: titleText,
            decoration: dc.formBorder("Event Title", '')),
        SizedBox(height: 8),
        InputChipField(),
        SizedBox(height: 8),
        DateTimeField(
          controller: startController,
          format: format,
          decoration: dc.formBorder('Starts at...', ''),
          onShowPicker: (context, currentValue) async {
            final date = await showDatePicker(
                context: context,
                firstDate: DateTime(2021),
                initialDate: currentValue ?? DateTime.now(),
                lastDate: DateTime(2022));
            if (date != null) {
              final time = await showTimePicker(
                context: context,
                initialTime:
                    TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
              );
              return DateTimeField.combine(date, time);
            } else {
              return currentValue;
            }
          },
        ),
        SizedBox(height: 8),
        DateTimeField(
          controller: endController,
          format: format,
          decoration: dc.formBorder('Ends at...', ''),
          onShowPicker: (context, currentValue) async {
            final date = await showDatePicker(
                context: context,
                firstDate: DateTime(2021),
                initialDate: currentValue ?? DateTime.now(),
                lastDate: DateTime(2022));
            if (date != null) {
              final time = await showTimePicker(
                context: context,
                initialTime:
                    TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
              );
              return DateTimeField.combine(date, time);
            } else {
              return currentValue;
            }
          },
        ),
        SizedBox(height: 8),
        ElevatedButton(
            onPressed: () {
              calendar.add({
                "title": titleText.text,
                "start": startController.text,
                "end": endController.text,
                "groups": [],
                "indvs": []
              });
            },
            child: Text("Create Event"))
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: signal,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Scaffold(
              appBar: dc.bar("Create an Event"),
              body: Container(
                  padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                  child: Column(children: allocator())));
        });
  }
}
