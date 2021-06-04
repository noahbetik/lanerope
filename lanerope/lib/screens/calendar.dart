import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lanerope/pagesDrawer.dart' as pd;

bool ios = Platform.isIOS;
bool android = Platform.isAndroid;

class Calendar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Calendar")),
      body: Material(),
      drawer: pd.PagesDrawer().importDrawer(context)
    );
  }
}
