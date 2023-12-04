import 'package:aplication/Pages/MyHomeApp_page%20copy.dart';
import 'package:aplication/Pages/LoginApp_page.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const MyHomeApp_page());
      case '/Home':
        return MaterialPageRoute(builder: (_) => LoginApp_page());
      case '/Login':
      default:
        return MaterialPageRoute(builder: (_) => const MyHomeApp_page());
    }
  }
}
