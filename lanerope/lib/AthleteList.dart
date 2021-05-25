import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';


class AthleteList extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _AthleteListState();
}

class _AthleteListState extends State<AthleteList> {
late SearchBar searchBar;

AppBar buildAppBar(BuildContext context) {
  return new AppBar(
      title: new Text('My Home Page'),
      actions: [searchBar.getSearchAction(context)]
  );
}

_AthleteListState() {
  searchBar = new SearchBar(
      inBar: false,
      setState: setState,
      onSubmitted: print,
      buildDefaultAppBar: buildAppBar
  );
}

@override
Widget build(BuildContext context) {
  return new Scaffold(
      appBar: searchBar.build(context)
  );
}
}