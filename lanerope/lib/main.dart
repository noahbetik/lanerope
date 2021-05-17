import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lanerope/globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

import './screens/home.dart';
import "./screens/login.dart";

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

  @override
  Widget build(BuildContext context) {
    print("inside build widget");
    return FutureBuilder(
      // Initialize FlutterFire:
      future: Future.wait([_initialization, _login]),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        // Check for errors
        /*if (snapshot.hasError) {
          return SomethingWentWrong();
        }*/
        print("waiting for future");

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          print("database connected");
          bool login = false;
          if (snapshot.data![1] == true) {
            login = true;
            print("user already logged in");
          }
          return new MaterialApp(
              debugShowCheckedModeBanner: false,
              title: "Lanerope",
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
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
