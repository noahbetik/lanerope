import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lanerope/calendar/RepeatEvent.dart';
import 'package:lanerope/calendar/RepeatState.dart';


class RepeatBloc extends Bloc<RepeatEvent, RepeatState> {
  RepeatBloc(RepeatState initialState) : super(initialState);

  @override
  Stream<RepeatState> mapEventToState(RepeatEvent event) async* {
    switch(event){
      case RepeatEvent.never:
        yield RepeatState.never;
      break;
      case RepeatEvent.daily:
        yield RepeatState.daily;
        break;
      case RepeatEvent.weekly:
        yield RepeatState.weekly;
        break;
      case RepeatEvent.monthly:
        yield RepeatState.monthly;
        break;
      case RepeatEvent.yearly:
        yield RepeatState.yearly;
        break;
    }
  }

}