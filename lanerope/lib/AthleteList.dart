import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lanerope/screens/adminPanel.dart' as admin;
import 'package:lanerope/screens/athleteInfo.dart' as info;
import 'package:lanerope/globals.dart' as globals;

CollectionReference users = FirebaseFirestore.instance.collection('users');
CollectionReference groups = FirebaseFirestore.instance.collection('groups');


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

  void _getNames() async { // maybe can do this with local copy
    List<List<String>> temp = [];
    if (widget.inclGroups == 'all') {
      users.get().then((snapshot) {
        snapshot.docs.forEach((element) {
          String gender;
          switch (element.get("gender")) {
            case "Male":
              {
                gender = "M";
              }
              break;
            case "Female":
              {
                gender = "F";
              }
              break;
            case "Non-Binary/Prefer not to say":
              {
                gender = "X";
              }
              break;
            default:
              {
                gender = "X";
              }
              break;
          }
          temp.add([
            element.get("first_name") + " " + element.get("last_name"),
            element.get("age") + gender,
            "ab/cd",
            element.id
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
            String gender;
            switch (element.get("gender")) {
              case "Male":
                {
                  gender = "M";
                }
                break;
              case "Female":
                {
                  gender = "F";
                }
                break;
              case "Non-Binary/Prefer not to say":
                {
                  gender = "X";
                }
                break;
              default:
                {
                  gender = "X";
                }
                break;
            }

            temp3.add([
              element.get("first_name") + " " + element.get("last_name"),
              element.get("age") + gender,
              "ab/cd",
              element.id
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
            temp.add(admin.filteredNames[i]);
          }
        }
        admin.filteredNames = temp;
      }
      return ListView.builder(
        itemCount: admin.filteredNames.length,
        itemBuilder: (BuildContext context, int index) {
          return AthleteTile(
              admin.filteredNames[index][0],
              admin.filteredNames[index][1],
              admin.filteredNames[index][2],
              admin.filteredNames[index][3]);
        },
      );
    } else {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: groupAthletes.length,
        itemBuilder: (BuildContext context, int index) {
          return AthleteTile(groupAthletes[index][0], groupAthletes[index][1],
              groupAthletes[index][2], groupAthletes[index][3]);
        },
      );
    }
  }
}

class AthleteTile extends StatefulWidget {
  final String fullName;
  final String aG;
  final String pronouns;
  final String uid;

  AthleteTile(this.fullName, this.aG, this.pronouns, this.uid) {
    createState();
  }

  @override
  State<StatefulWidget> createState() {
    return _AthleteTileState();
  }
}

class _AthleteTileState extends State<AthleteTile> {

  @override
  Widget build(BuildContext context) {
    List<String> localInfo = info.allAthletes[widget.uid];
    print(localInfo);
    String group = localInfo[4]; // feels sketchy to do this with list indices
    return ListTile(
      title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(widget.aG), // age/gender
        Text(widget.fullName),
        Text(
          widget.pronouns,
          style: TextStyle(color: Colors.grey), // pronouns
        ),
      ]),
      trailing: IconButton(
        icon: const Icon(Icons.edit_sharp),
        onPressed: () async {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                  title: Text("Athlete Info"),
                  content: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                          return Container(
                              padding: const EdgeInsets.all(0.0),
                              width: double.maxFinite,
                              height: 500, // auto adjust better
                              child: ListView(padding: const EdgeInsets.all(0),
                                  //shrinkWrap: true, // probably not necessary
                                  children: <Widget>[
                                    ListTile(
                                        title:
                                            Text("Name: " + localInfo[2])),
                                    ListTile(
                                        title: Text("Age: " + localInfo[3])),
                                    ListTile(
                                        title: Text(
                                            "Birthday: " + localInfo[6])),
                                    ListTile(
                                        title:
                                            Text("Gender: " + localInfo[5])),
                                    ListTile(
                                        title: Text("Current Group: " +
                                            localInfo[4])),
                                    /*Container(
                                      alignment: Alignment.bottomLeft,
                                      padding: EdgeInsets.only(
                                          top: 8.0, bottom: 3.0),
                                      child: DropdownButton<String>(
                                        hint: Text('dumb?'),
                                        value: group,
                                        items: [
                                          'AG1',
                                          'AG2',
                                          'AG3',
                                          "Elite",
                                          'Novice 2'
                                        ].map<DropdownMenuItem<String>>(
                                            (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                        onChanged: (String? newGroup) {
                                          setState(() {
                                            group = newGroup!;
                                          });
                                        },
                                      ),
                                    ),*/
                                    ElevatedButton(
                                        onPressed: () {
                                        },
                                        child: Text("Submit"))
                                  ]));
                      })));
        },
      ),
    );
  }
}
