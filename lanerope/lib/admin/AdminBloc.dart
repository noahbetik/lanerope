import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lanerope/admin/AdminEvent.dart';
import 'package:lanerope/admin/AdminState.dart';
import 'package:lanerope/screens/adminPanel.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  AdminBloc(AdminState initialState) : super(initialState);

  TextEditingController filter = TextEditingController();

  @override
  Stream<AdminState> mapEventToState(AdminEvent event) async* {
    switch (event.runtimeType) {
      case ShowSearch:
        yield SearchShown(filterText: "");
        break;
      case ShowCards:
        yield CardsShown();
        break;
      case UpdateFilter:
        if (filter.text.isEmpty){
          filteredNames = names;
          yield SearchShown(filterText: '');
        }
        else {
          yield SearchShown(filterText: event.filterText);
        }
        break;
      case AddGroup:
        yield CardsShown();
        break;
      case SubGroup:
        yield CardsShown();
        break;
      case AssignGroup:
        yield CardsShown();
        break;
      case UpdateBoxes:
        yield CardsShown();
        break;
    }
  }

}