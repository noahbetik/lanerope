import 'package:flutter/material.dart';
import 'package:lanerope/screens/account.dart';
import 'package:lanerope/globals.dart' as globals;
import 'dart:io';
import 'package:string_validator/string_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'home.dart';

bool ios = Platform.isIOS;
bool android = Platform.isAndroid;

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
    return Scaffold(
        appBar: AppBar(
          title: Text("Login"),
          backgroundColor: Colors.blueAccent,
        ),
        body: Container(
            padding: EdgeInsets.all(15.0),
            child: Column(children: <Widget>[
              Form(
                key: _accountKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                        controller: emailGrabber,
                        decoration: InputDecoration(hintText: 'Email address'),
                        validator: (user) {
                          if (user == null || checkLength(user, 2, 40)) {
                            return "Must be between 2 and 40 characters";
                          }
                          return null;
                        }),
                    TextFormField(
                        controller: passGrabber,
                        decoration: InputDecoration(hintText: 'Password'),
                        validator: (pass) {
                          if (pass == null || checkLength(pass, 8, 40)) {
                            return "Must be between 8 and 40 characters";
                          }
                          if (!isAscii(pass)) {
                            return "Invalid character in password";
                          }
                          return null;
                        }),
                    ElevatedButton(
                      onPressed: () async {
                        int errorCode = 0;
                        if (_accountKey.currentState!.validate()) {
                          try {
                            UserCredential userCredential =
                                await log.signInWithEmailAndPassword(
                                    email: emailGrabber.text,
                                    password: passGrabber.text);
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'user-not-found') {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      "An account doesn't exist with that email...")));
                            } else if (e.code == 'wrong-password') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Incorrect password!')));
                            }
                          }
                          log.authStateChanges().listen((User? user) async {
                            if (user != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Welcome back!')));
                              var current = log.currentUser;
                              globals.currentUID = current!.uid;
                              globals.role = await globals.findRole();
                              final prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setBool("login", true);
                              Navigator.pushAndRemoveUntil(
                                  context,
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
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => Account()),
                        (Route<dynamic> route) => false);
                  },
                  child: Text("Create an account"))
            ])));
  }
}
