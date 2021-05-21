import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lanerope/pagesDrawer.dart' as pd;
import 'package:expandable/expandable.dart';
import 'package:lanerope/AddGroup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lanerope/globals.dart' as globals;

bool ios = Platform.isIOS;
bool android = Platform.isAndroid;
StreamController<bool> ctrl = StreamController<bool>.broadcast();
Stream<bool> redraw = ctrl.stream;

List<Widget> groupBoxes = [];
List<String> subs = [];

getGroups() async {
  await FirebaseFirestore.instance.collection('groups').get().then((snapshot) {
    snapshot.docs.forEach((element) {
      groupBoxes.add(GroupBox(groupName: element.id));
    });
  });
}



class AdminPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Admin Panel")),
      floatingActionButton: AddButton(),
      body: ExpandableTheme(
          data: const ExpandableThemeData(
              iconColor: Colors.blue, useInkWell: true),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: <Widget>[
              SelectionCard(),
            ],
          )),
      drawer: pd.PagesDrawer().importDrawer(context),
    );
  }
}

class SelectionCard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SelectionCardState();
  }
}

class _SelectionCardState extends State<SelectionCard> {
  // needs to draw state from separate button

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: redraw,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          List<Widget> subWidgets = List<Widget>.from(groupBoxes);
          subWidgets.add(ElevatedButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(globals.currentUID)
                    .update({"groups": FieldValue.arrayUnion(subs)});
              },
              child: Text("Subscribe")));
          return ExpandableNotifier(
              child: Padding(
            padding: const EdgeInsets.all(10),
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: <Widget>[
                  ScrollOnExpand(
                    scrollOnExpand: true,
                    scrollOnCollapse: false,
                    child: ExpandablePanel(
                      theme: const ExpandableThemeData(
                        headerAlignment: ExpandablePanelHeaderAlignment.center,
                        tapBodyToCollapse: true,
                        tapBodyToExpand: true,
                      ),
                      header: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "Group Selection",
                            style: Theme.of(context).textTheme.bodyText1,
                          )),
                      collapsed: Container(),
                      expanded: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: subWidgets),
                      builder: (_, collapsed, expanded) {
                        return Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Expandable(
                            collapsed: collapsed,
                            expanded: expanded,
                            theme: const ExpandableThemeData(crossFadePoint: 0),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ));
        });
  }
}

class GroupCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const loremIpsum =
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
    return ExpandableNotifier(
        child: Padding(
      padding: const EdgeInsets.all(10),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 150,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.rectangle,
                ),
              ),
            ),
            ScrollOnExpand(
              scrollOnExpand: true,
              scrollOnCollapse: false,
              child: ExpandablePanel(
                theme: const ExpandableThemeData(
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  tapBodyToCollapse: true,
                ),
                header: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "ExpandablePanel",
                      style: Theme.of(context).textTheme.bodyText1,
                    )),
                collapsed: Text(
                  loremIpsum,
                  softWrap: true,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                expanded: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    for (var _ in Iterable.generate(5))
                      Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text(
                            loremIpsum,
                            softWrap: true,
                            overflow: TextOverflow.fade,
                          )),
                  ],
                ),
                builder: (_, collapsed, expanded) {
                  return Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: Expandable(
                      collapsed: collapsed,
                      expanded: expanded,
                      theme: const ExpandableThemeData(crossFadePoint: 0),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

class GroupBox extends StatefulWidget {
  const GroupBox({Key? key, required this.groupName}) : super(key: key);

  final String groupName;

  getName(){
    return this.groupName;
  }

  @override
  State<GroupBox> createState() => _GroupBoxState();
}

class _GroupBoxState extends State<GroupBox> {
  bool checked = false;
  CollectionReference user = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    String name = widget.groupName;
    return CheckboxListTile(
      title: Text(name),
      value: checked == true,
      onChanged: (bool? value) {
        setState(() {
          checked = value! ? true : false;
        });
        if (checked == true){
          subs.add(name);
        }
        else if (subs.contains(name)){
          subs.remove(name);
        }
      },
      secondary: const Icon(Icons.hourglass_empty),
    );
  }
}

class AddButton extends StatelessWidget {
  final _nameKey = GlobalKey<FormState>();
  final nameGrabber = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                title: Text("Add Group"),
                content: Container(
                    width: double.maxFinite,
                    height: 100,
                    child: ListView(padding: const EdgeInsets.all(8),
                        // shrinkWrap: true, // probably not necessary
                        children: <Widget>[
                          // can add more settings for group attributes here
                          Form(
                            key: _nameKey,
                            child: Column(
                              children: <Widget>[
                                TextFormField(
                                    controller: nameGrabber,
                                    decoration:
                                        InputDecoration(hintText: 'Group Name'),
                                    validator: (name) {
                                      if (name == null) {
                                        return "Please give this group a name";
                                      }
                                      return null;
                                    }),
                                ElevatedButton(
                                    onPressed: () {
                                      if (_nameKey.currentState!.validate()) {
                                        groupBoxes.add(GroupBox(
                                            groupName: nameGrabber.text));
                                        AddGroup(nameGrabber.text).addGroup();
                                        nameGrabber.clear();
                                        ctrl.add(true);
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: Text("Add Group"))
                              ],
                            ),
                          )
                        ]))));
      },
      child: const Icon(Icons.person_add_rounded),
      backgroundColor: Colors.green,
    );
  }
}
