import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lanerope/calendar/CalendarEvent.dart';
import 'package:lanerope/calendar/CalendarState.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc(CalendarState initialState) : super(initialState);
  CalendarFormat currentFormat = CalendarFormat.month;

  @override
  Stream<CalendarState> mapEventToState(CalendarEvent event) async* {
    if (event is SelectDate) {
      yield DateSelected(event.todaysEvents);
    } else if (event is ChangeFormat) {
      yield FormatChanged();
    }
  }
}
