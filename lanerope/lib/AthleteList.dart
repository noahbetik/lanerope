import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lanerope/globals.dart' as globals;
import 'package:lanerope/screens/adminPanel.dart' as admin;

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

  void _getNames() async {
    // maybe can do this with local copy
    List<List<String>> temp = [];
    if (widget.inclGroups == 'all') {
      globals.allAthletes.forEach((element, value) {
        String gender;
        switch (value[5]) {
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
        temp.add(
            [value[0] + " " + value[1], value[3] + gender, "ab/cd", element]);
      });
      setState(() {
        admin.names = temp;
        admin.filteredNames = admin.names;
      });
    } else {
      List<List<String>> temp3 = [];
      globals.allAthletes.forEach((element, value) {
        if (value[4] == widget.inclGroups) {
          String gender;
          switch (value[5]) {
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

          temp3.add(
              [value[0] + " " + value[1], value[3] + gender, "ab/cd", element]);
          setState(() {
            groupAthletes = temp3;
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

      // long-term readability/maintainability would be better if this was dictionary instead of list
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
  Future<void> _refresh() async {
    admin.ctrl.add(true);
  }

  @override
  Widget build(BuildContext context) {
    List<String> localInfo = globals.allAthletes[widget.uid];
    String group = localInfo[4]; // feels sketchy to do this with list indices
    String assignedGroup = '';
    return ListTile(
      title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(widget.aG), // age/gender
        Text(widget.fullName),
        Text(
          widget.pronouns,
          style: TextStyle(color: Colors.grey), // pronouns
        ),
      ]),
      leading: IconButton(
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
                        height: 400, // auto adjust better if possible
                        child: ListView(padding: const EdgeInsets.all(0),
                            //shrinkWrap: true, // probably not necessary
                            children: <Widget>[
                              ListTile(title: Text("Name: " + localInfo[2])),
                              ListTile(title: Text("Age: " + localInfo[3])),
                              ListTile(
                                  title: Text("Birthday: " + localInfo[6])),
                              ListTile(title: Text("Gender: " + localInfo[5])),
                              ListTile(
                                  title:
                                      Text("Current Group: " + localInfo[4])),
                              Container(
                                alignment: Alignment.bottomLeft,
                                padding: EdgeInsets.only(top: 8.0, bottom: 3.0),
                                child: DropdownButton<String>(
                                  hint: Text('Please select a group'),
                                  value: group,
                                  items: globals.everyGroup
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? newGroup) {
                                    setState(() {
                                      group = newGroup!;
                                      assignedGroup = newGroup;
                                    });
                                  },
                                ),
                              ),
                              ElevatedButton(
                                  onPressed: () async {
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                                // not ideal
                                                content: Center(
                                              child: CircularProgressIndicator
                                                  .adaptive(),
                                              widthFactor: 1,
                                              heightFactor: 1,
                                            )));
                                    DocumentSnapshot snap1 =
                                        await users.doc(widget.uid).get();
                                    List<dynamic> thisGroups =
                                        snap1.get("groups");
                                    DocumentSnapshot snap3 =
                                        await groups.doc(assignedGroup).get();
                                    List<dynamic> groupToAdd =
                                        snap3.get("athletes");

                                    if (thisGroups.isNotEmpty) {
                                      if(thisGroups[0] != "unassigned"){
                                        DocumentSnapshot snap2 =
                                            await groups.doc(localInfo[4]).get();
                                        List<dynamic> groupToRemove =
                                            snap2.get("athletes");
                                        groupToRemove.remove(widget.uid);
                                        groups
                                            .doc(localInfo[4])
                                            .update({"athletes": groupToRemove});}
                                      thisGroups.remove(localInfo[4]);
                                    }
                                    thisGroups.add(assignedGroup);
                                    groupToAdd.add(widget.uid);
                                    groups
                                        .doc(assignedGroup)
                                        .update({"athletes": groupToAdd});
                                    users
                                        .doc(widget.uid)
                                        .update({"groups": thisGroups});
                                    globals.allAthletes[widget.uid] =
                                        await globals.getInfo(widget.uid);
                                    _refresh();
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  child: Text("Submit"))
                            ]));
                  })));
        },
      ),
    );
  }
}
