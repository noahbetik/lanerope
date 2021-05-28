import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lanerope/AddUser.dart';
import 'package:string_validator/string_validator.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart' as dt;
import 'package:intl/intl.dart';
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
  String gender = 'Non-Binary/Prefer not to say';
  final _accountKey = GlobalKey<FormState>();
  final emailGrabber = TextEditingController();
  final passGrabber = TextEditingController();
  final fNameGrabber = TextEditingController();
  final lNameGrabber = TextEditingController();
  final dateGrabber = TextEditingController();

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
    dateGrabber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final format = DateFormat("yyyy-MM-dd");
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
                  TextFormField(
                      // do space scrubbing
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
                  TextFormField(
                      // do space scrubbing
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
                  Container(
                    alignment: Alignment.bottomLeft,
                    padding: EdgeInsets.only(top: 8.0, bottom: 3.0),
                    child: DropdownButton<String>(
                      hint: Text("Please choose your gender"),
                      value: gender,
                      items: <String>[
                        'Male',
                        'Female',
                        'Non-Binary/Prefer not to say',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? setGender) {
                        setState(() {
                          gender = setGender!;
                        });
                      },
                    ),
                  ),
                  dt.DateTimeField(
                    controller: dateGrabber,
                    format: format,
                    onShowPicker: (context, currentValue) {
                      return showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          initialDate: currentValue ?? DateTime.now(),
                          lastDate: DateTime.now());
                    },
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

                        DateTime birthday = DateTime.parse(dateGrabber.text);

                        String yearsSince(DateTime from) {
                          from = DateTime(from.year, from.month, from.day);
                          DateTime to = DateTime.now();
                          int result = ((to.difference(from).inHours / 24).round() / 365).floor();
                          return result.toString();
                        }

                        String uid = auth.currentUser!.uid;
                        AddUser dbAdd = AddUser(
                          uid,
                          role,
                          fNameGrabber.text,
                          lNameGrabber.text,
                          gender,
                          yearsSince(birthday),
                          birthday,
                        );
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
