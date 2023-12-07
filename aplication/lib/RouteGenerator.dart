import 'package:aplication/Pages/CartApp_page.dart';
import 'package:aplication/Pages/LoginApp_page.dart';
import 'package:aplication/Pages/MyHomeApp_page.dart';
import 'package:aplication/Pages/ProdutosApp_page.dart';
import 'package:aplication/Pages/RegisterApp_page.dart';
import 'package:aplication/Pages/UserApp_page.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const MyHomeApp_page());
      case '/Login':
        return MaterialPageRoute(builder: (_) => LoginApp_page());
      case '/Register':
        return MaterialPageRoute(builder: (_) => Register_page());
      case '/Produtos':
        return MaterialPageRoute(builder: (_) => ProdutosApp_page());
      case '/Carrinho':
        return MaterialPageRoute(builder: (_) => CartApp_page());
      case '/User':
        return MaterialPageRoute(builder: (_) => UserApp_page());
      default:
        return MaterialPageRoute(builder: (_) => const MyHomeApp_page());
    }
  }
}
