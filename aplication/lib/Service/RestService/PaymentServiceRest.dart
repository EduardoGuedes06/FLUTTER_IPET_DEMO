import 'dart:convert';
import 'package:aplication/Models/Cart.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:aplication/Models/Product.dart';

class PaymentServiceRest {
  //POST
  Future<bool> finalizePayment(String userId) async {
    final String apiUrl =
        'https://apicoremobile.azurewebsites.net/finalizarCompra/' + userId;
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
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

  //GET
  Future<List<Cart>> getCart(String user) async {
    final String apiUrl =
        'https://apicoremobile.azurewebsites.net/obter-carrinho/' + user;

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        return data
            .map((item) => Cart(
                  id: item['id'],
                  nome: item['nomeProduto'],
                  valor: item['valor'].toDouble(),
                  data: item['dataCadastro'],
                  qtd: item['qtde'],
                ))
            .toList();
      }
    } catch (error) {
      print('Error during cart request: $error');
    }

    return [];
  }
}
