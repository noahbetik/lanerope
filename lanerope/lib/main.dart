import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lanerope/DesignChoices.dart' as dc;
import 'package:lanerope/globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

import './screens/home.dart';
import "./screens/login.dart";

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print("aight lets go");
  runApp(Lanerope());
}

Future<bool> loginState() async {
  final prefs = await SharedPreferences.getInstance();
  final bool _status =
      prefs.getBool("login") ?? false; // future bool is true if logged in
  print(_status);
  globals.role = prefs.getString("role") ?? "";
  return _status;
}

Future<void> lockedSubs() async {
  final prefs = await SharedPreferences.getInstance();
  globals.subLock = prefs.getBool("boxesLocked") ?? false; // future bool is true if logged in
}


class Lanerope extends StatefulWidget {
  // Create the initialization Future outside of `build`:
  @override
  _LaneropeState createState() {
    print("inside stateful widget");
    return _LaneropeState();
  }
}

class _LaneropeState extends State<Lanerope> {
  /// The future is part of the state of our widget. We should not call `initializeApp`
  /// directly inside [build].

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final Future<bool> _login = loginState();
  final Future<void> _subs = lockedSubs();

  @override
  Widget build(BuildContext context) {
    print("inside build widget");
    return FutureBuilder(
      // Initialize FlutterFire:
      future: Future.wait([_initialization, _login, _subs]),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return CircularProgressIndicator.adaptive(); // do something better
        }
        print("waiting for future");

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          print("database connected");
          bool login = false;
          globals.findRole(); // may make usage in homepage redundant
          globals.allGroups();
          globals.allInfo();
          //globals.allAnnouncements();
          globals.allEvents();
          globals.getContacts();
          globals.getConvos();
          var current = FirebaseAuth.instance.currentUser;
          if (snapshot.data![1] == true) {
            globals.currentUID = current!.uid;
            login = true;
            print("user already logged in");
          }
          return new MaterialApp(
              debugShowCheckedModeBanner: false,
              title: "Lanerope",
              theme: dc.appTheme,
              navigatorKey: navigatorKey,
              home: login == true ? Home() : Login(),
              routes: <String, WidgetBuilder>{
                '/home': (BuildContext context) => new Home(),
                '/login': (BuildContext context) => new Login()
              });
        }
        // Otherwise, show something whilst waiting for initialization to complete
        return CircularProgressIndicator
            .adaptive(); // great place to put a splash screen or something
      },
    );
  }
}
