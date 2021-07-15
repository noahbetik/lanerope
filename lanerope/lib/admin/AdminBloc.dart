import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lanerope/admin/AdminEvent.dart';
import 'package:lanerope/admin/AdminState.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  AdminBloc(AdminState initialState) : super(initialState);

  @override
  Stream<AdminState> mapEventToState(AdminEvent event) async* {
    switch (event) {
      case AdminEvent.showSearch:
        yield AdminState.searchShown;
        break;
      case AdminEvent.showCards:
        yield AdminState.cardsShown;
        break;
      case AdminEvent.updateFilter:
        // TODO: Handle this case.
        break;
      case AdminEvent.AddGroup:
        // TODO: Handle this case.
        break;
      case AdminEvent.SubGroup:
        // TODO: Handle this case.
        break;
      case AdminEvent.AssignGroup:
        // TODO: Handle this case.
        break;
      case AdminEvent.UpdateBoxes:
        // TODO: Handle this case.
        break;
    }
  }

}