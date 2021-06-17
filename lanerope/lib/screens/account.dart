import 'dart:io';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart' as dt;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lanerope/AddUser.dart';
import 'package:lanerope/DesignChoices.dart' as dc;
import 'package:string_validator/string_validator.dart';

import 'home.dart';

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
    RegExp check = new RegExp(r'[^a-z. ]', caseSensitive: false);

    if (check.allMatches(text).length > 0) {
      return true;
    }

    return false;
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
    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text("Create an account"),
              backgroundColor: Colors.blueAccent,
            ),
            body: Container(
                padding: EdgeInsets.all(15.0),
                child: Form(
                  key: _accountKey,
                  child: ListView(
                    children: <Widget>[
                      TextFormField(
                          // need spacing between input boxes
                          // do space scrubbing
                          controller: fNameGrabber,
                          decoration: dc.formBorder("Given Name", ''),
                          validator: (name) {
                            if (name == null || checkLength(name, 2, 40)) {
                              return "Must be between 2 and 40 characters";
                            }
                            if (alphaOnly(name)) {
                              return "Please use only letters and spaces";
                            }
                            return null;
                          }),
                      Padding(padding: EdgeInsets.only(bottom: 8.0)),
                      TextFormField(
                          // do space scrubbing
                          controller: lNameGrabber,
                          decoration: dc.formBorder("Family Name", ''),
                          validator: (name) {
                            if (name == null || checkLength(name, 2, 40)) {
                              return "Must be between 2 and 40 characters";
                            }
                            if (alphaOnly(name)) {
                              return "Please use only letters and spaces";
                            }
                            return null;
                          }),
                      Padding(padding: EdgeInsets.only(bottom: 8.0)),
                      TextFormField(
                          controller: emailGrabber,
                          decoration: dc.formBorder("Email Address", ''),
                          validator: (email) {
                            if (email == null || !isEmail(email)) {
                              // need a better email checking method with null safety
                              return "Please enter a valid email address";
                            }
                            return null;
                          }),
                      Padding(padding: EdgeInsets.only(bottom: 8.0)),
                      TextFormField(
                          controller: passGrabber,
                          decoration: dc.formBorder("Password",
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
                        padding: EdgeInsets.only(bottom: 8.0),
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
                        padding: EdgeInsets.only(bottom: 8.0),
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
                        decoration:
                            dc.formBorder('Please enter your birthday', ''),
                        onShowPicker: (context, currentValue) {
                          return showDatePicker(
                              context: context,
                              firstDate: DateTime(1900),
                              initialDate: currentValue ?? DateTime.now(),
                              lastDate: DateTime.now());
                        },
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 8.0)),
                      ElevatedButton(
                        onPressed: () async {
                          if (_accountKey.currentState!.validate()) {
                            try {
                              await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                email: emailGrabber.text.trim(),
                                // pull from forms
                                password: passGrabber.text.trim(),
                              );
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'weak-password') {
                                print('The password provided is too weak.');
                              } else if (e.code == 'email-already-in-use') {
                                print(
                                    'The account already exists for that email.');
                              }
                            } catch (e) {
                              print(e);
                            }

                            DateTime birthday =
                                DateTime.parse(dateGrabber.text);

                            String yearsSince(DateTime from) {
                              from = DateTime(from.year, from.month, from.day);
                              DateTime to = DateTime.now();
                              int result =
                                  ((to.difference(from).inHours / 24).round() /
                                          365)
                                      .floor();
                              return result.toString();
                            }

                            String uid = auth.currentUser!.uid;
                            AddUser dbAdd = AddUser(
                              uid,
                              role,
                              fNameGrabber.text.trim(),
                              lNameGrabber.text.trim(),
                              gender,
                              yearsSince(birthday),
                              birthday,
                            );
                            dbAdd.addUser();

                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Creating account...')));
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => Home()),
                                (Route<dynamic> route) => false);
                          }
                        },
                        child: Text("Create Account"),
                      )
                    ],
                  ),
                ))));
  }
}
