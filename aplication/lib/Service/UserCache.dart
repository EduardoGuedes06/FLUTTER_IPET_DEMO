import 'package:flutter/material.dart';
import 'package:aplication/Models/User.dart';
import 'package:aplication/Service/RestService/LoginServiceRest.dart';

class UserCache extends ChangeNotifier {
  User? _loggedInUser;

  Future<bool> loginUser(String email, String password) async {
    try {
      final userService = LoginServiceRest();
      final loginData = await userService.login(email, password);

      if (loginData != null) {
        final userId = loginData.userId;
        final userEmail = loginData.email;

        _loggedInUser = User(userId: userId ?? '', email: userEmail ?? '');
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (error) {
      print('Error during login: $error');
      return false;
    }
  }

  Future<bool> RegisterUser(String email, String password) async {
    try {
      final userService = LoginServiceRest();
      final loginData = await userService.login(email, password);

      if (loginData != null) {
        final userId = loginData.userId;
        final userEmail = loginData.email;

        _loggedInUser = User(userId: userId ?? '', email: userEmail ?? '');
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (error) {
      print('Error during login: $error');
      return false;
    }
  }

  User? getLoggedInUser() {
    return _loggedInUser;
  }

  bool isUserLoggedIn() {
    return _loggedInUser != null;
  }
}
