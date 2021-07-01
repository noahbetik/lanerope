import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lanerope/calendar/ICFEvent.dart';
import 'package:lanerope/calendar/ICFState.dart';


class ICFBloc extends Bloc<ICFEvent, ICFState> {
  ICFBloc(ICFState initialState) : super(initialState);

  @override
  Stream<ICFState> mapEventToState(ICFEvent event) async* {
    if (event is ShowFields){
      // show the regular screen
      print("going to fields");
      yield FieldsShown();
    }
    else if (event is ShowPredictions){
      // show the list of predictions from text controller
      print("going to predictions");
      yield PredictionsShown();
    }
  }

}