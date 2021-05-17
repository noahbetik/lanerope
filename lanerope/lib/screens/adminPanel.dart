import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lanerope/pagesDrawer.dart' as pd;
import 'package:expandable/expandable.dart';

bool ios = Platform.isIOS;
bool android = Platform.isAndroid;

class AdminPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Admin Panel")),
      body: ExpandableTheme(
        data: const ExpandableThemeData(
          iconColor: Colors.blue,
          useInkWell: true
        ),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: <Widget> [
            SelectionCard(),
          ],
        )
      ),
      drawer: pd.PagesDrawer().importDrawer(context),
    );
  }
}


class SelectionCard extends StatelessWidget{

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
                    collapsed: Column(
                        children: <Widget>[
                      Text(
                        loremIpsum,
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.fade,
                      ),

                    ]
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

class GroupCard extends StatelessWidget{
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
                          style: Theme.of(context).textTheme.body2,
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
  const GroupBox({Key? key}) : super(key: key);

  @override
  State<GroupBox> createState() => _GroupBoxState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _GroupBoxState extends State<GroupBox> {
  int x = 0;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: const Text('Animate Slowly'),
      value: x != 1.0,
      onChanged: (bool? value) {
        setState(() {
          x = 1; // placeholder
        });
      },
      secondary: const Icon(Icons.hourglass_empty),
    );
  }
}
