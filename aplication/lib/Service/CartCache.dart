import 'package:aplication/Models/Cart.dart';
import 'package:aplication/Service/RestService/CartServiceRest.dart';
import 'package:flutter/material.dart';

class CartCache extends ChangeNotifier {
  static Map<String, List<Cart>> _cache = {};

  Future<List<Cart>> getCart(String user) async {
    if (_cache.containsKey(user)) {
      print('Retornando dados do cache para o usuário $user');
      return _cache[user]!;
    }
    final List<Cart> cart = await CartServiceRest().getCart(user);
    _cache[user] = cart;

    return cart;
  }
}
