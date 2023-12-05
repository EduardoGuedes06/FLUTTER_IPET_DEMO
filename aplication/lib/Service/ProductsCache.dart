import 'package:aplication/Models/Product.dart';
import 'package:flutter/material.dart';
import 'package:aplication/Models/User.dart';

class ProductsCache extends ChangeNotifier {
  static final List<Product> _products = [
    Product(
      id: '00000000-0000-0000-0000-000000000001',
      nome: 'Ração',
      valor: 20.0,
      image: 'racao.jpg',
    ),
    Product(
      id: '00000000-0000-0000-0000-000000000002',
      nome: 'Osso',
      valor: 30.0,
      image: 'racao.jpg',
    ),
    Product(
      id: '00000000-0000-0000-0000-000000000003',
      nome: 'Areia',
      valor: 25.0,
      image: 'racao.jpg',
    ),
    Product(
      id: '00000000-0000-0000-0000-000000000004',
      nome: 'Brinquedo',
      valor: 40.0,
      image: 'racao.jpg',
    ),
    Product(
      id: '00000000-0000-0000-0000-000000000005',
      nome: 'Ração Pedigree',
      valor: 15.0,
      image: 'racao.jpg',
    ),
    Product(
      id: '00000000-0000-0000-0000-000000000006',
      nome: 'Brinquedo para Gato',
      valor: 35.0,
      image: 'racao.jpg',
    ),
    Product(
      id: '00000000-0000-0000-0000-000000000007',
      nome: 'Kit Higienico',
      valor: 22.0,
      image: 'racao.jpg',
    ),
    Product(
      id: '00000000-0000-0000-0000-000000000008',
      nome: 'Coleira',
      valor: 28.0,
      image: 'racao.jpg',
    ),
  ];

  static List<Product> getProducts() {
    return _products;
  }
}
