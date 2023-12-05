import 'package:aplication/RouteGenerator.dart';
import 'package:aplication/Service/ProductsCache.dart';
import 'package:aplication/Service/UserCache.dart';
import 'package:aplication/Service/UserRegister.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserCache()),
        ChangeNotifierProvider(create: (_) => UserRegister()),
        ChangeNotifierProvider(create: (_) => ProductsCache()),
      ],
      child: MaterialApp(
        initialRoute: '/',
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    ),
  );
}
