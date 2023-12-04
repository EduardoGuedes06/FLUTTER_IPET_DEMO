import 'package:aplication/Pages/MyHomeApp_page%20copy.dart';
import 'package:aplication/Pages/LoginApp_page.dart';
import 'package:aplication/Pages/RegisterApp_page.dart';
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
      default:
        return MaterialPageRoute(builder: (_) => const MyHomeApp_page());
    }
  }
}
