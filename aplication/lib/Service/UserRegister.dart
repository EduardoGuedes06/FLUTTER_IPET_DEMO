import 'package:flutter/material.dart';
import 'package:aplication/Models/User.dart';
import 'package:aplication/Service/RestService/RegisterServiceRest.dart';

class UserRegister extends ChangeNotifier {
  UserRegister? _loggedInUser;

  Future<bool> RegisterUser(String Nome, String doc, String email,
      String password, String password_) async {
    try {
      final userService = RegisterServiceRest();
      final loginData =
          await userService.Register(Nome, doc, email, password, password_);

      if (loginData != null) {
        final userId = loginData.userId;
        final userEmail = loginData.email;

        return true;
      } else {
        return false;
      }
    } catch (error) {
      print('Error during login: $error');
      return false;
    }
  }
}
