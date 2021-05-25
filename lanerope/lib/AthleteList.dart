import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:lanerope/screens/athleteInfo.dart' as info;

class AthleteList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    //info.getInfo(uid);
    return _AthleteListState();
  }
}

class _AthleteListState extends State<AthleteList> {
  late SearchBar searchBar;

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
        title: new Text('My Home Page'),
        actions: [searchBar.getSearchAction(context)]);
  }

  _AthleteListState() {
    searchBar = new SearchBar(
        inBar: false,
        setState: setState,
        onSubmitted: print,
        buildDefaultAppBar: buildAppBar);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(appBar: searchBar.build(context));
  }
}

class AthleteTile extends StatelessWidget {
  final String fullName;

  AthleteTile(String name) : fullName = name;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(fullName),
      trailing: IconButton(
        icon: const Icon(Icons.edit_sharp),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                  title: Text("Athlete Info"),
                  content: Container(
                      width: double.maxFinite,
                      height: 100,
                      child: ListView(padding: const EdgeInsets.all(8),
                          // shrinkWrap: true, // probably not necessary
                          children: <Widget>[]))));
        },
      ),
    );
  }
}
