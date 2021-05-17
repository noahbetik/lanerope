import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lanerope/pagesDrawer.dart' as pd;

bool ios = Platform.isIOS;
bool android = Platform.isAndroid;

class CoachDM extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Direct Messages")),
      body: Material(),
      drawer: pd.PagesDrawer().importDrawer(context)
    );
  }
}
