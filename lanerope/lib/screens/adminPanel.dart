import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lanerope/AddGroup.dart';
import 'package:lanerope/AthleteList.dart';
import 'package:lanerope/admin/AdminBloc.dart';
import 'package:lanerope/admin/AdminEvent.dart';
import 'package:lanerope/admin/AdminState.dart';
import 'package:lanerope/globals.dart' as globals;
import 'package:lanerope/pagesDrawer.dart' as pd;

bool ios = Platform.isIOS;
bool android = Platform.isAndroid;
StreamController<bool> ctrl = StreamController<bool>.broadcast();
Stream<bool> redraw = ctrl.stream;
StreamController<bool> box = StreamController<bool>.broadcast();
Stream<bool> boxDraw = box.stream;
CollectionReference groupWrangler =
    FirebaseFirestore.instance.collection('groups');

List<Widget> groupBoxes = [];
List<Widget> cards = [];
List<String> subs = [];

String searchText = '';
List<List<String>> names = [];
List<List<String>> filteredNames = [];

Future<List> _checkedGroups() async {
  List inGroups = [];
  await users.doc(globals.currentUID).get().then((snap) {
    inGroups = snap.get("groups");
    print("in fx");
    print(inGroups);
  });
  return inGroups;
}

Future<void> getGroups() async {
  groupBoxes.clear();
  List preChecked = await _checkedGroups();
  print("in fx");
  print(preChecked);

  QuerySnapshot snapshot = await groupWrangler.get();
  snapshot.docs.forEach((element) {
    if (preChecked.contains(element.id)) {
      groupBoxes.add(GroupBox(groupName: element.id, preChecked: true));
    } else {
      groupBoxes.add(GroupBox(groupName: element.id));
    }
  });
}

Future<void> getCards() async {
  if (globals.currentUID == '') {
    globals.getUID();
  }
  cards.clear();
  cards.add(SelectionCard());
  await FirebaseFirestore.instance
      .collection('users')
      .doc(globals.currentUID) // sometimes null, fix
      .get()
      .then((snapshot) {
    List<dynamic> myGroups = snapshot.get("groups");
    for (int i = 0; i < myGroups.length; i++) {
      cards.add(GroupCard(myGroups[i]));
    }
  });
}

class AdminPanel extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AdminPanelState();
  }
}

class _AdminPanelState extends State<AdminPanel> {
  final TextEditingController filter = new TextEditingController();
  Icon _searchIcon =
      new Icon(Icons.search); // can these be moved to BLoC state?
  Widget _appBarTitle = new Text('Admin Panel');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        // *probably* don't need to change this? but could
        future: Future.wait([getGroups(), getCards()]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return BlocProvider(
              create: (BuildContext context) => AdminBloc(CardsShown()),
              child: Scaffold(
                  appBar: AppBar(
                      centerTitle: true,
                      elevation: 0,
                      title: BlocBuilder<AdminBloc, AdminState>(
                          builder: (context, adminState) {
                        return _appBarTitle;
                      }),
                      actions: [
                        Builder(
                            builder: (context) => IconButton(
                                  icon: BlocBuilder<AdminBloc, AdminState>(
                                      builder: (context, adminState) {
                                    return _searchIcon;
                                  }),
                                  onPressed: () {
                                    if (this._searchIcon.icon == Icons.search) {
                                      this._searchIcon = Icon(Icons.close);
                                      this._appBarTitle = TextField(
                                        controller: filter,
                                        onChanged: (value) {
                                          BlocProvider.of<AdminBloc>(context)
                                              .add(UpdateFilter(
                                                  filterText: value));
                                        },
                                        decoration: InputDecoration(
                                            hintText: 'Find an athlete'),
                                      );
                                      BlocProvider.of<AdminBloc>(context)
                                          .add(ShowSearch());
                                    } else {
                                      this._searchIcon = Icon(Icons.search);
                                      this._appBarTitle = Text('Admin Panel');
                                      filteredNames = names;
                                      filter.clear();
                                      BlocProvider.of<AdminBloc>(context)
                                          .add(ShowCards());
                                    }
                                  },
                                )),
                      ]), // good
                  floatingActionButton: AddButton(),
                  drawer: pd.PagesDrawer().importDrawer(context), // good
                  body: BlocBuilder<AdminBloc, AdminState>(
                      builder: (context, adminState) {
                    if (adminState is CardsShown) {
                      return ExpandableTheme(
                          data: const ExpandableThemeData(
                              iconColor: Colors.blue, useInkWell: true),
                          child: ListView(
                            children: cards,
                          ));
                    } else {
                      return AthleteList('all');
                    }
                  })),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                  title: this._appBarTitle,
                  centerTitle: true,
                  elevation: 0), // should probably just replace with text
              body: Center(child: CircularProgressIndicator.adaptive()),
              // make it look less stupid
              drawer: pd.PagesDrawer().importDrawer(context),
            );
          }
        });
  }
}

class SelectionCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        // useless once BLoC provided
        stream: redraw,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          List<Widget> subWidgets = List<Widget>.from(groupBoxes);
          subWidgets.add(ElevatedButton(
              onPressed: () {
                // move to BLoC, passing sub
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(globals.currentUID)
                    .update({"groups": FieldValue.arrayUnion(subs)});
                for (int x = 0; x < subs.length; x++) {
                  groupWrangler.doc(subs[x]).update({
                    "coaches": FieldValue.arrayUnion([globals.currentUID])
                  });
                }
              },
              child: Text("Subscribe")));
          return ExpandableNotifier(
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: <Widget>[
                  ScrollOnExpand(
                    scrollOnExpand: true,
                    scrollOnCollapse: true,
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
                      collapsed: SizedBox.shrink(),
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
          );
        });
  }
}

class GroupCard extends StatelessWidget {
  final String cardName;

  GroupCard(this.cardName);

  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 150,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover, image: AssetImage("images/bun.JPG")),
                  shape: BoxShape.rectangle,
                ),
              ),
            ),
            ScrollOnExpand(
              scrollOnExpand: true,
              scrollOnCollapse: true,
              child: ExpandablePanel(
                controller: ExpandableController(initialExpanded: false),
                theme: const ExpandableThemeData(
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  tapBodyToCollapse: true,
                ),
                header: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      cardName,
                      style: Theme.of(context).textTheme.bodyText1,
                    )),
                collapsed: SizedBox.shrink(),
                expanded: AthleteList(cardName),
                builder: (_, collapsed, expanded) {
                  return Padding(
                    padding: EdgeInsets.all(0.0),
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
    );
  }
}

class GroupBox extends StatefulWidget {
  const GroupBox({Key? key, this.preChecked = false, required this.groupName})
      : super(key: key);

  final String groupName;
  final bool preChecked;

  getName() {
    return this.groupName;
  }

  @override
  State<GroupBox> createState() => _GroupBoxState();
}

class _GroupBoxState extends State<GroupBox> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  bool checked = false;

  @override
  void initState() {
    super.initState();
    if (widget.preChecked == true) {
      checked = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    String name = widget.groupName;

    return CheckboxListTile(
      title: Text(name),
      value: checked == true,
      onChanged: globals.subLock == true
          ? null
          : (bool? value) {
              setState(() {
                // replace with BLoC calls
                checked = value! ? true : false;
              });
              if (checked == true) {
                subs.add(name);
              } else if (subs.contains(name)) {
                subs.remove(name);
              }
            },
      secondary: const Icon(Icons.hourglass_empty),
    );
  }
}

class AddButton extends StatelessWidget {
  // probably fine as is
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
                                        NewGroup(nameGrabber.text).addGroup();
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
      child: const Icon(Icons.add_comment_rounded),
      backgroundColor: Colors.redAccent,
    );
  }
}

// want a card for all athletes
