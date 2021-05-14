import 'package:flutter/material.dart';
import 'package:lanerope/screens/home.dart';
import 'dart:io';
import 'package:string_validator/string_validator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lanerope/AddUser.dart';

import 'login.dart';

bool ios = Platform.isIOS;
bool android = Platform.isAndroid;
FirebaseAuth auth = FirebaseAuth.instance;

class Account extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  String name = '';
  String role = "Athlete";
  final _accountKey = GlobalKey<FormState>();
  final emailGrabber = TextEditingController();
  final passGrabber = TextEditingController();
  final fNameGrabber = TextEditingController();
  final lNameGrabber = TextEditingController();

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
  void dispose() {
    // to be used later?? idk where
    emailGrabber.dispose();
    passGrabber.dispose();
    fNameGrabber.dispose();
    lNameGrabber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Create an account"),
          backgroundColor: Colors.blueAccent,
        ),
        body: Container(
            padding: EdgeInsets.all(15.0),
            child: Form(
              key: _accountKey,
              child: Column(
                children: <Widget>[
                  TextFormField( // do space scrubbing
                      controller: fNameGrabber,
                      decoration: InputDecoration(hintText: 'Given name'),
                      validator: (name) {
                        if (name == null || checkLength(name, 2, 40)) {
                          return "Must be between 2 and 40 characters";
                        }
                        if (alphaOnly(name)) {
                          return "Please use only lowercase and capital letters";
                        }
                        return null;
                      }),
                  TextFormField( // do space scrubbing
                      controller: lNameGrabber,
                      decoration: InputDecoration(hintText: 'Family name'),
                      validator: (name) {
                        if (name == null || checkLength(name, 2, 40)) {
                          return "Must be between 2 and 40 characters";
                        }
                        if (alphaOnly(name)) {
                          return "Please use only lowercase and capital letters";
                        }
                        return null;
                      }),
                  TextFormField(
                      controller: emailGrabber,
                      decoration: InputDecoration(hintText: 'Email address'),
                      validator: (email) {
                        if (email == null || !isEmail(email)) {
                          // need a better email checking method with null safety
                          return "Please enter a valid email address";
                        }
                        return null;
                      }),
                  /*TextFormField(
                      decoration:
                          InputDecoration(hintText: 'Please choose a username'),
                      validator: (user) {
                        if (user == null || checkLength(user, 2, 40)) {
                          return "Must be between 2 and 40 characters";
                        } // should probably restrict special characters to underscore and period
                        return null;
                      }),*/
                  // firebase only has implementation for email sign-up
                  TextFormField(
                      controller: passGrabber,
                      decoration: InputDecoration(
                          hintText: 'Please choose a password',
                          helperText:
                              '8-40 characters\nMust include at least one capital letter and one number'),
                      validator: (pass) {
                        if (pass == null || checkLength(pass, 8, 40)) {
                          return "Must be between 8 and 40 characters";
                        }
                        if (!isAscii(pass)) {
                          return "Invalid character in password";
                        }
                        if (!contains(pass, new RegExp(r'[A-Z]'))) {
                          return "Must contain at least one capital letter";
                        }
                        if (!contains(pass, new RegExp(r'[0-9]'))) {
                          return "Must contain at least one number";
                        }
                        return null;
                      }),
                  Container(
                    alignment: Alignment.bottomLeft,
                    padding: EdgeInsets.only(top: 8.0, bottom: 3.0),
                    child: DropdownButton<String>(
                      value: role,
                      items: <String>[
                        'Athlete',
                        'Parent/Guardian',
                        'Coach/Admin',
                        'Assistant Coach' // need validation for coach roles
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newRole) {
                        setState(() {
                          role = newRole!;
                        });
                      },
                    ),
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: () async {
                      if (_accountKey.currentState!.validate()) {
                        try {
                          UserCredential userCredential = await FirebaseAuth
                              .instance
                              .createUserWithEmailAndPassword(
                            email: emailGrabber.text, // pull from forms
                            password: passGrabber.text,
                          );
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            print('The password provided is too weak.');
                          } else if (e.code == 'email-already-in-use') {
                            print('The account already exists for that email.');
                          }
                        } catch (e) {
                          print(e);
                        }

                        String uid = auth.currentUser!.uid;
                        AddUser dbAdd = AddUser(
                            uid, fNameGrabber.text, lNameGrabber.text, role);
                        dbAdd.addUser();

                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Creating account...')));
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => Login()),
                            (Route<dynamic> route) => false);
                      }
                    },
                    child: Text("Create Account"),
                  )
                ],
              ),
            )));
  }
}
