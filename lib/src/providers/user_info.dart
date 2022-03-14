import 'package:flutter/material.dart';

class UserInfo with ChangeNotifier {
  int _uid;

  String _firstName = "";
  String _lastName = "";
  String _email = "";

  get firstName {
    return _firstName;
  }

  get lastName {
    return _lastName;
  }

  get email {
    return _email;
  }

  int get uid => this._uid;

  set uid(int value) => this._uid = value;

  set firstName(String firstName) {
    _firstName = firstName;
    notifyListeners();
  }

  set lastName(String lastName) {
    _lastName = lastName;
    notifyListeners();
  }

  set email(String email) {
    _email = email;
    notifyListeners();
  }
}
