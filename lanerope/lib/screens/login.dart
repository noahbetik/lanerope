import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lanerope/DesignChoices.dart' as dc;
import 'package:lanerope/globals.dart' as globals;
import 'package:lanerope/screens/account.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:string_validator/string_validator.dart';

import 'home.dart';

bool ios = Platform.isIOS;
bool android = Platform.isAndroid;
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String name = '';
  FirebaseAuth log = FirebaseAuth.instance;
  final _accountKey = GlobalKey<FormState>();
  final emailGrabber = TextEditingController();
  final passGrabber = TextEditingController();

  bool checkLength(String text, int min, int max) {
    if (text.length < min || text.length > max) {
      return true;
    }
    return false;
  }

  bool alphaOnly(String text) {
    return !isAlpha(text);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
          key: _scaffoldKey,
          appBar: dc.bar("Login"),
          body: Container(
              padding: EdgeInsets.all(15.0),
              child: Column(children: <Widget>[
                Form(
                  key: _accountKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                          controller: emailGrabber,
                          decoration: dc.formBorder("Email Address", ''),
                          validator: (user) {
                            user = user!.trim();
                            if (user == null || checkLength(user, 2, 40)) {
                              return "Must be between 2 and 40 characters";
                            }
                            return null;
                          }),
                      Padding(padding: EdgeInsets.only(bottom: 8.0)),
                      TextFormField(
                          controller: passGrabber,
                          decoration: dc.formBorder("Password", ''),
                          obscureText: true,
                          validator: (pass) {
                            if (pass == null || checkLength(pass, 8, 40)) {
                              return "Must be between 8 and 40 characters";
                            }
                            if (!isAscii(pass)) {
                              return "Invalid character in password";
                            }
                            return null;
                          }),
                      Padding(padding: EdgeInsets.only(bottom: 8.0)),
                      ElevatedButton(
                        onPressed: () async {
                          if (_accountKey.currentState!.validate()) {
                            try {
                              await log.signInWithEmailAndPassword(
                                  email: emailGrabber.text.trim(),
                                  password: passGrabber.text.trim());
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'user-not-found') {
                                emailGrabber.clear();
                                passGrabber.clear();
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        "An account doesn't exist with that email...")));
                              } else if (e.code == 'wrong-password') {
                                passGrabber.clear();
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text('Incorrect password!')));
                              }
                            }
                            log.authStateChanges().listen((User? user) async {
                              if (user != null) {
                                ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
                                    SnackBar(content: Text('Welcome back!')));
                                var current = log.currentUser;
                                globals.currentUID = current!.uid;
                                globals.role = await globals.findRole();
                                final prefs =
                                await SharedPreferences.getInstance();
                                prefs.setBool("login", true);
                                prefs.setString("role", globals.role);
                                globals.findRole(); // may make usage in homepage redundant
                                globals.allGroups();
                                globals.allInfo();
                                //globals.allAnnouncements();
                                globals.allEvents();
                                globals.getContacts();
                                globals.getConvos();
                                Navigator.pushAndRemoveUntil(
                                    _scaffoldKey.currentContext!,
                                    MaterialPageRoute(
                                        builder: (context) => Home()),
                                        (Route<dynamic> route) => false);
                              }
                            });
                          }
                        },
                        child: Text("Log In"),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Text("New here? Create an account"),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Account()),
                      );
                    },
                    child: Text("Create an account"))
              ]))));
  }
}