import 'package:flutter/material.dart';
import 'dart:io';

bool ios = Platform.isIOS;
bool android = Platform.isAndroid;

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String name = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Login Page"),
          backgroundColor: Colors.blueAccent,
        ),
        body: Container(
          padding: EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  hintText: 'Given name'
          ),
                onSubmitted: (String string) {
                  setState(() {
                    name = string;
                  });
                },
              ),
              TextField(
                decoration: InputDecoration(
                    hintText: 'Family name'
                ),
                onSubmitted: (String string) {
                  setState(() {
                    name = string;
                  });
                },
              ),
              TextField(
                decoration: InputDecoration(
                    hintText: 'Please choose a username'
                ),
                onSubmitted: (String string) {
                  setState(() {
                    name = string;
                  });
                },
              ),
              TextField(
                decoration: InputDecoration(
                    hintText: 'Please choose a password',
                    helperText: '8-40 characters\nMust include at least one capital letter and one number'
                ),
                onSubmitted: (String string) {
                  setState(() {
                    name = string;
                  });
                },
              ),
            ],
          ),
        ));
  }
}
