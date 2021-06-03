import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lanerope/AthleteList.dart';
import 'package:lanerope/screens/athleteInfo.dart';
import 'package:lanerope/pagesDrawer.dart' as pd;
import 'package:expandable/expandable.dart';
import 'package:lanerope/AddGroup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lanerope/globals.dart' as globals;

bool ios = Platform.isIOS;
bool android = Platform.isAndroid;
StreamController<bool> ctrl = StreamController<bool>.broadcast();
Stream<bool> redraw = ctrl.stream;
CollectionReference groupWrangler =
    FirebaseFirestore.instance.collection('groups');

List<Widget> groupBoxes = [];
List<Widget> cards = [];
List<String> subs = [];

String searchText = '';
List<List<String>> names = [];
List<List<String>> filteredNames = [];

Future<void> getGroups() async {
  groupBoxes.clear();
  QuerySnapshot snapshot = await groupWrangler.get();
  snapshot.docs.forEach((element) {
    groupBoxes.add(GroupBox(groupName: element.id));
  });
  print("all groups: ");
  print(groupBoxes);
}

Future<void> getCards() async {
  cards.clear();
  cards.add(SelectionCard());
  if (globals.currentUID == '') {
    globals.getUID();
  }
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
  final TextEditingController _filter = new TextEditingController();
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text('Admin Panel');

  _AdminPanelState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          searchText = "";
          filteredNames = names;
        });
      } else {
        setState(() {
          searchText = _filter.text;
        });
      }
    });
  }

  PreferredSizeWidget _buildBar(BuildContext context) {
    return new AppBar(centerTitle: true, title: _appBarTitle, actions: [
      new IconButton(
        icon: _searchIcon,
        onPressed: _searchPressed,
      ),
    ]);
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = Icon(Icons.close);
        this._appBarTitle = TextField(
          controller: _filter,
          decoration: InputDecoration(hintText: 'Find an athlete'),
        );
      } else {
        this._searchIcon = Icon(Icons.search);
        this._appBarTitle = Text('Admin Panel');
        filteredNames = names;
        _filter.clear();
      }
    });
  }

  Widget view() {
    if (this._searchIcon.icon == Icons.search) {
      return ExpandableTheme(
          data: const ExpandableThemeData(
              iconColor: Colors.blue, useInkWell: true),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: cards,
          ));
    } else {
      return AthleteList('all');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([getGroups(), getCards()]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              appBar: _buildBar(context),
              floatingActionButton: AddButton(),
              body: view(),
              drawer: pd.PagesDrawer().importDrawer(context),
            );
          } else {
            return Scaffold(
              appBar: _buildBar(context),
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
    print("inside selection card");
    print(groupBoxes);
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
                for (int x = 0; x < subs.length; x++) {
                  groupWrangler.doc(subs[x]).update({
                    "coaches": FieldValue.arrayUnion([globals.currentUID])
                  });
                }
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
          ));
        });
  }
}

class GroupCard extends StatelessWidget {
  final String cardName;

  GroupCard(this.cardName);

  @override
  Widget build(BuildContext context) {
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
    ));
  }
}

class GroupBox extends StatefulWidget {
  const GroupBox({Key? key, required this.groupName}) : super(key: key);

  final String groupName;

  getName() {
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
      child: const Icon(Icons.add_comment_rounded),
      backgroundColor: Colors.green,
    );
  }
}

// want a card for all athletes
