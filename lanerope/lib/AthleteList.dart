import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lanerope/screens/adminPanel.dart' as admin;
import 'package:lanerope/screens/athleteInfo.dart' as info;

class AthleteList extends StatefulWidget {

  final String inclGroups;

  AthleteList(this.inclGroups){
    createState();
  }

  @override
  State<StatefulWidget> createState(){
    return _AthleteListState();
  }
}

class _AthleteListState extends State<AthleteList> {

  void _getNames() async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    CollectionReference groups = FirebaseFirestore.instance.collection('groups');
    List<String> temp = [];

    if (widget.inclGroups == 'all'){
      users.get().then((snapshot){
        snapshot.docs.forEach((element) {
          temp.add(element.get("first_name") + " " + element.get("last_name"));
          });
      });
      setState(() {
        admin.names = temp;
        admin.filteredNames = admin.names;
      });
    }
    else {
      // read from group db
      return;
    }
  }


  @override
  void initState() {
    this._getNames(); // pull from db
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    if (admin.searchText.isNotEmpty) {
      List<String> temp = [];
      for (int i = 0; i < admin.filteredNames.length; i++) {
        if (admin.filteredNames[i].toLowerCase().contains(admin.searchText.toLowerCase())) {
          temp.add(admin.filteredNames[i]);
        }
      }
      admin.filteredNames = temp;
    }
    return ListView.builder(
      itemCount: admin.filteredNames.length,
      itemBuilder: (BuildContext context, int index) {
        return AthleteTile(admin.filteredNames[index]);
      },
    );

  }
}

class AthleteTile extends StatelessWidget {
  final String fullName;

  AthleteTile(String name) : fullName = name;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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
