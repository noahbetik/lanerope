import 'package:lanerope/Guardian.dart';

import 'Coach.dart';
import 'Guardian.dart';
import 'Athlete.dart';

abstract class User {
  String firstName = '';
  String lastName = ''; // how to deal with non-western names?
  String username = '';
  String password = '';
  String role = '';

  User(String fName, String lName, String user, String pass){
    this.firstName = fName;
    this.lastName = lName;
    this.username = user;
    this.password = pass;

  }



}