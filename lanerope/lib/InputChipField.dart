import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lanerope/DesignChoices.dart' as dc;

TextEditingController chipCtrl = TextEditingController();
final _fieldKey = GlobalKey<FormState>();
List<Widget> fieldList = [];
List<EntityChip> chips = [];
StreamController<bool> ctrl = StreamController<bool>.broadcast();
Stream<bool> redraw = ctrl.stream; // maybe wanna make this global some day

class EntityChip {
  late InputChip chip;
  late String name;

  EntityChip(String text) {
    this.name = text;
    this.chip = InputChip(
        label: Text(text),
        deleteIcon: Icon(Icons.clear),
        onDeleted: () {
          chips.removeWhere((EntityChip c) {
            return c.name == text;
          });
          ctrl.add(true);
        });
  }
}

class InputChipField extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FieldState();
  }
}

class _FieldState extends State<InputChipField> {
  void resetField() {
    fieldList.clear();
    fieldList.add(ChipGen());
    for (int i=0; i<chips.length; i++){
      fieldList.add(chips[i].chip);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: redraw,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          print("rewind da bit");
          resetField();
          return Wrap(children: fieldList,
          spacing: 8.0,
          );
        });
  }
}

class ChipGen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ChipGenState();
  }
}

class _ChipGenState extends State<ChipGen> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        keyboardType: TextInputType.multiline,
        controller: chipCtrl,
        onChanged: (value) {
          print(value.characters);
          if (value.endsWith(' ')) {
            // wanted newline but doesn't work?
            print("new chip");
            String text = chipCtrl.text.substring(0, chipCtrl.text.length - 1);
            // get every except newline
            setState(() {
              print(text);
              chips.add(EntityChip(text));
              chipCtrl.clear();
              ctrl.add(true);
            });
          }
        },
        decoration: dc.formBorder("People/Groups", ''));
  }
}
