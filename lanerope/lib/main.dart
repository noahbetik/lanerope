import 'package:flutter/material.dart';
import './screens/home.dart';

void main() {
  runApp(new LaneropeApp());
}

class LaneropeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        title: "Lanerope",
        home: Scaffold(
            appBar: AppBar(title: Text("Club Name Here")), body: Home()));
  }
}
