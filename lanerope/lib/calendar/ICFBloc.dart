import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lanerope/calendar/ICFEvent.dart';
import 'package:lanerope/calendar/ICFState.dart';


class ICFBloc extends Bloc<ICFEvent, ICFState> {
  ICFBloc(ICFState initialState) : super(initialState);

  @override
  Stream<ICFState> mapEventToState(ICFEvent event) async* {
    switch (event) {
      case ICFEvent.fields:
        yield FieldsShown();
        break;
      case ICFEvent.predictions:
        yield PredictionsShown();
        break;
    }
  }

}