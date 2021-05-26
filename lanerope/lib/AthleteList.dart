import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lanerope/screens/athleteInfo.dart' as info;

class AthleteList extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _AthleteListState();
  }
}

class _AthleteListState extends State<AthleteList> {

  void _getNames() async {
    return;
  }


  @override
  void initState() {
    this._getNames(); // pull from db
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: []
    );

  }
}

class AthleteTile extends StatelessWidget {
  final String fullName;

  AthleteTile(String name) : fullName = name;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(children: [
        Text("19M"), // age/gender
        Text(fullName),
        Text(
          "he/him",
          style: TextStyle(color: Colors.grey), // pronouns
        ),
      ]),



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
