import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:aplication/Models/Product.dart';

class CartServiceRest {
  final String apiUrl = 'https://localhost:7094/adicionar-produto';

  Future<bool> addToCart(String userId, Product product) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "id": Uuid().v4(),
          "usuarioId": userId,
          "nomeProduto": product.nome,
          "qtde": 1,
          "valor": product.valor,
        }),
      );

      if (response.statusCode == 200) {
        final dynamic data = jsonDecode(response.body);

        if (data != null && data['success'] == true) {
          return true;
        }
      }
    } catch (error) {
      print('Error during add to cart request: $error');
    }

    return false;
  }
}
