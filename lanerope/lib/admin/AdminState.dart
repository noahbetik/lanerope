//enum AdminState {searchShown, cardsShown}

abstract class AdminState {}

class SearchShown extends AdminState {
  String filterText;

  SearchShown({required this.filterText});
}

class CardsShown extends AdminState {}