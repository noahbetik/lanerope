import 'package:flutter/material.dart';
import 'dart:io';
import 'package:string_validator/string_validator.dart';

bool ios = Platform.isIOS;
bool android = Platform.isAndroid;

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String name = '';

  final _accountKey = GlobalKey<FormState>();

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
                        decoration: InputDecoration(hintText: 'Username'),
                        validator: (user) {
                          if (user == null || checkLength(user, 2, 40)) {
                            return "Must be between 2 and 40 characters";
                          }
                          return null;
                        }),
                    TextFormField(
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
                      onPressed: () {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_accountKey.currentState!.validate()) {
                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Welcome back!')));
                          Navigator.of(context).pushReplacementNamed('/home');
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
                  onPressed: () {}, child: Text("Create an account"))
            ])));
  }
}
