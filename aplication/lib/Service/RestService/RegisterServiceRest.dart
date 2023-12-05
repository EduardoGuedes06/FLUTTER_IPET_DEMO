import 'dart:convert';
import 'package:aplication/Models/Register.dart';
import 'package:http/http.dart' as http;

class UserRegisterResponse {
  final String? userId;
  final String? email;

  UserRegisterResponse({this.userId, this.email});
}

class RegisterServiceRest {
  final String apiUrl = 'https://localhost:7094/nova-conta-mobile';

  Future<UserRegisterResponse?> Register(String Nome, String doc, String email,
      String password, String password_) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'nome': Nome,
          'doc': doc,
          'cep': "12903803",
          'email': email,
          'numero': "123",
          'password': password,
          'confirmPassword': password_
        }),
      );

      if (response.statusCode == 200) {
        final dynamic data = jsonDecode(response.body);

        if (data != null && data['success'] == true) {
          final userToken = data['data']['userToken'];
          final userId = userToken['id'] as String?;
          final email = userToken['email'] as String?;

          return UserRegisterResponse(userId: userId, email: email);
        }
      }
    } catch (error) {
      print('Error during login request: $error');
    }

    return null;
  }
}
