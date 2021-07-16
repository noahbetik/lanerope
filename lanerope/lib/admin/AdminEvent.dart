//enum AdminEvent {showSearch, showCards, updateFilter, AddGroup, SubGroup, AssignGroup, UpdateBoxes}

abstract class AdminEvent {
  late String filterText;
}

class ShowSearch extends AdminEvent{
  String filterText;

  ShowSearch({this.filterText = ''});
}

class ShowCards extends AdminEvent{}

class UpdateFilter extends AdminEvent{
  String filterText;

  UpdateFilter({required this.filterText});
}

class AddGroup extends AdminEvent{
}

class SubGroup extends AdminEvent{}

class AssignGroup extends AdminEvent{}

class UpdateBoxes extends AdminEvent{}