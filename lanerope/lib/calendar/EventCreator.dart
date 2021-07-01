import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lanerope/DesignChoices.dart' as dc;
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:lanerope/InputChipField.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lanerope/calendar/ICFEvent.dart';

import 'ICFBloc.dart';
import 'ICFState.dart';

List<EntityChip> chips = [];
List<Widget> displayChips = [];
String searchText = '';
List<String> names = ["AG2", "AG3", "AG4", "Novice2", "CoachNoah"]; // db pull
List<String> filteredNames = [];

final CollectionReference calendar =
    FirebaseFirestore.instance.collection('calendar');

Widget chipGen() {
  displayChips.clear();
  for (int i=0; i<chips.length; i++){
    displayChips.add(chips[i].chip);
  }
  return Wrap(children: displayChips, spacing: 8.0,);
}


void checkFilter() {
  if (searchText.isNotEmpty) {
    List<String> tempList = [];
    for (int i = 0; i < filteredNames.length; i++) {
      if (filteredNames[i].toLowerCase().contains(searchText.toLowerCase())) {
        tempList.add(filteredNames[i]);
      }
    }
    filteredNames = tempList;
  }
  print(filteredNames);
}

class EntityChip {
  late InputChip chip;
  late String name;

  EntityChip(String text, BuildContext context) {
    this.name = text;
    this.chip = InputChip(
        label: Text(text),
        deleteIcon: Icon(Icons.clear),
        onDeleted: () {
          chips.removeWhere((EntityChip c) {
            return c.name == text;
          });
          BlocProvider.of<ICFBloc>(context).add(ShowFields());
        });
  }
}

class EventCreator extends StatelessWidget {
  final String givenTitle;
  final String givenStart;
  final String givenEnd;
  final FocusNode _focus = new FocusNode();
  final format = DateFormat("yyyy-MM-dd HH:mm");

  late final TextEditingController startController;
  late final TextEditingController endController;
  late final TextEditingController titleText;
  final TextEditingController chipCtrl = TextEditingController();

  EventCreator(this.givenTitle, this.givenStart, this.givenEnd) {
    titleText = TextEditingController(text: givenTitle);
    startController = TextEditingController(text: givenStart);
    endController = TextEditingController(text: givenEnd);
  } // fix for datetimes

  Widget buildList(BuildContext context) {
    checkFilter();
    return ListView.builder(
      shrinkWrap: true,
      itemCount: filteredNames.length,
      itemBuilder: (BuildContext context, int index) {
        return new ListTile(
            title: Text(filteredNames[index]),
            onTap: () {
              print(filteredNames[index]);
              chips.add(EntityChip(filteredNames[index], context));
              chipCtrl.clear();
              BlocProvider.of<ICFBloc>(context).add(ShowFields());
            }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: dc.bar("Create an Event"),
        body: BlocProvider(
            create: (_) => ICFBloc(FieldsShown()),
            lazy: false,
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
              children: [
                TextFormField(
                    maxLength: 100, // idk
                    controller: titleText,
                    decoration: dc.formBorder("Event Title", '')),
                SizedBox(height: 8),
                Builder(
                    builder: (context) => TextFormField(
                    focusNode: _focus,
                    keyboardType: TextInputType.multiline,
                    controller: chipCtrl,
                    onChanged: (value) {
                      BlocProvider.of<ICFBloc>(context).add(ShowPredictions());
                      if (value.endsWith(' ')) {
                        // wanted newline but doesn't work?
                        String text = chipCtrl.text
                            .substring(0, chipCtrl.text.length - 1);
                        // get every except newline
                        print(text);
                        chips.add(EntityChip(text, context));
                        chipCtrl.clear();
                        BlocProvider.of<ICFBloc>(context).add(ShowFields());
                      }
                      else if (chipCtrl.text.isEmpty){
                        filteredNames = names;
                        searchText = '';
                      }
                      else {
                        filteredNames = names;
                        searchText = chipCtrl.text;
                      }
                    },
                    decoration: dc.formBorder("People/Groups", ''))),
                BlocBuilder<ICFBloc, ICFState>(builder: (_, icfState) {
                  if (icfState is PredictionsShown) {
                    return buildList(context); // replace with predictions list
                  } else {
                    return ListView(
                      shrinkWrap: true,
                      children: [
                        chipGen(),
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
                                initialTime: TimeOfDay.fromDateTime(
                                    currentValue ?? DateTime.now()),
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
                                initialTime: TimeOfDay.fromDateTime(
                                    currentValue ?? DateTime.now()),
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
                      ],
                    );
                  }
                })
              ],
            )));
  }
}
