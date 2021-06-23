import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lanerope/DesignChoices.dart' as dc;

TextEditingController chipCtrl = TextEditingController();
final _fieldKey = GlobalKey<FormState>();
List<Widget> fieldList = [];
List<InputChip> chips = [];

class InputChipField extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FieldState();
  }
}

class _FieldState extends State<InputChipField> {

  void resetField() {

  }

  @override
  Widget build(BuildContext context) {

    return Wrap(children: fieldList);
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
          if (value.endsWith(' ')) { // wanted newline but doesn't work?
            print("newline");
            String text = chipCtrl.text.substring(0, chipCtrl.text.length - 1);
            setState(() {
              print(text);
              chips.add(InputChip(label: Text(text))); // get every except newline
            });
          }
        },
        decoration: dc.formBorder("People/Groups", ''));
  }

}