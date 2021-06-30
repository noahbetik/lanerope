import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lanerope/DesignChoices.dart' as dc;
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:lanerope/InputChipField.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lanerope/calendar/ICFBloc.dart';
import 'package:lanerope/calendar/ICFEvent.dart';
import 'ICFState.dart';

final FocusNode _focus = new FocusNode();
final TextEditingController _controller = new TextEditingController();

class InputChipField extends StatelessWidget {


  final List<Widget> fields = [
    TextFormField(
      focusNode: _focus,
    ),
  ];

  final List<Widget> predictions = [];

  _onFocusChange(BuildContext context) {
    BlocProvider.of<ICFBloc>(context).add(ShowPredictions());
  }


  @override
  Widget build(BuildContext context) {
    _focus.addListener(_onFocusChange(context));
    return BlocProvider(create: (_) => ICFBloc(FieldsShown()),
    child: BlocBuilder<ICFBloc, ICFState> (builder: (_, icfState){
      if (icfState is PredictionsShown){
        return ListView(
          children: predictions,
        );
      }
      else {
        return ListView(
          children: fields,
        );
      }
    }),
    );
  }
  
}