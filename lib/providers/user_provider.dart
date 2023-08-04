import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/resources/auth_methods.dart';

class UserProvider with ChangeNotifier{
  User _user = const User(
    bio: 'null',
    email: 'null',
    photoUrl: 'null',
    uid: 'null',
    username: 'null',
    followers: [],
    following: [],
  );
  final AuthMethods _authMethods = AuthMethods();

  User get getUser => _user!;

  Future<void> refreshUser() async { //to update user details instantly
    User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}