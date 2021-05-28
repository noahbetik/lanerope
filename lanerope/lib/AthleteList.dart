import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lanerope/screens/adminPanel.dart' as admin;
import 'package:lanerope/screens/athleteInfo.dart' as info;

class AthleteList extends StatefulWidget {
  final String inclGroups;

  AthleteList(this.inclGroups) {
    createState();
  }

  @override
  State<StatefulWidget> createState() {
    return _AthleteListState();
  }
}

class _AthleteListState extends State<AthleteList> {
  List<List<String>> groupAthletes = [];

  void _getNames() async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    CollectionReference groups =
        FirebaseFirestore.instance.collection('groups');
    List<List<String>> temp = [];
    if (widget.inclGroups == 'all') {
      users.get().then((snapshot) {
        snapshot.docs.forEach((element) {
          temp.add([
            element.get("first_name") + " " + element.get("last_name"),
            element.get("age") + element.get("gender"),
            "ab/cd"
          ]);
        });
      });
      setState(() {
        admin.names = temp;
        admin.filteredNames = admin.names;
      });
    } else {
      List<dynamic> temp2 = [];
      List<List<String>> temp3 = [];
      groups.doc(widget.inclGroups).get().then((snapshot) {
        temp2 = snapshot.get("athletes");
        for (int i = 0; i < temp2.length; i++) {
          users.doc(temp2[i]).get().then((element) {
            temp3.add([
              element.get("first_name") + " " + element.get("last_name"),
              element.get("age") + element.get("gender"),
              "ab/cd"
            ]);
            setState(() {
              groupAthletes = temp3;
            });
          });
        }
      });
    }
  }

  @override
  void initState() {
    this._getNames(); // pull from db
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.inclGroups == "all") {
      if (admin.searchText.isNotEmpty) {
        List<List<String>> temp = [];
        for (int i = 0; i < admin.filteredNames.length; i++) {
          if (admin.filteredNames[i][0]
              .toLowerCase()
              .contains(admin.searchText.toLowerCase())) {
            temp.add([admin.filteredNames[i][0]]);
          }
        }
        admin.filteredNames = temp;
      }
      return ListView.builder(
        itemCount: admin.filteredNames.length,
        itemBuilder: (BuildContext context, int index) {
          return AthleteTile(admin.filteredNames[index][0],
              admin.filteredNames[index][1], admin.filteredNames[index][2]);
        },
      );
    } else {
      print("length is " + groupAthletes.length.toString());
      return ListView.builder(
        shrinkWrap: true,
        itemCount: groupAthletes.length,
        itemBuilder: (BuildContext context, int index) {
          return AthleteTile(groupAthletes[index][0], groupAthletes[index][1],
              groupAthletes[index][2]);
        },
      );
    }
  }
}

class AthleteTile extends StatelessWidget {
  final String fullName;
  final String aG;
  final String pronouns;

  AthleteTile(this.fullName, this.aG, this.pronouns);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(aG), // age/gender
        Text(fullName),
        Text(
          pronouns,
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
