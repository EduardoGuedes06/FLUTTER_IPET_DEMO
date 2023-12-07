import 'dart:convert';
import 'package:http/http.dart' as http;

class UserLoginResponse {
  final String? userId;
  final String? email;

  UserLoginResponse({this.userId, this.email});
}

class LoginServiceRest {
  final String apiUrl = 'https://apicoremobile.azurewebsites.net/entrar-mobile';

  Future<UserLoginResponse?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final dynamic data = jsonDecode(response.body);

        if (data != null && data['success'] == true) {
          final userToken = data['data']['userToken'];
          final userId = userToken['id'] as String?;
          final email = userToken['email'] as String?;

          return UserLoginResponse(userId: userId, email: email);
        }
      }
    } catch (error) {
      print('Error during login request: $error');
    }

    return null;
  }
}
