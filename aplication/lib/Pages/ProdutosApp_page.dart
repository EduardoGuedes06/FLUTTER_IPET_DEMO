import 'package:flutter/material.dart';
import 'package:aplication/Models/Product.dart';
import 'package:aplication/Service/ProductsCache.dart';

class ProdutosApp_page extends StatefulWidget {
  @override
  _ProdutosApp_pageState createState() => _ProdutosApp_pageState();
}

class _ProdutosApp_pageState extends State<ProdutosApp_page> {
  @override
  Widget build(BuildContext context) {
    final List<Product> products = ProductsCache.getProducts();

    return Scaffold(
      backgroundColor: Colors.red, // Fundo vermelho
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            // Adicione a navegação para a página anterior aqui
          },
        ),
        title: Text(
          'Produtos',
          style: TextStyle(
            fontSize: 60,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Lista de Produtos',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final Product product = products[index];
                  return ListTile(
                    title: Text(
                      product.nome,
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      'R\$ ${product.valor.toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.white),
                    ),
                    leading: Image.asset(
                      'assets/wwwroot/Produtos/${product.image}',
                      width: 40,
                      height: 40,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 100.0,
        decoration: BoxDecoration(
          color: Color.fromRGBO(222, 218, 245, 1.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, -1),
              blurRadius: 30.0,
            ),
          ],
        ),
        child: BottomNavigationBar(
          elevation: 0.0,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          iconSize: 38.0,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.crop_square_outlined,
                color: Color.fromRGBO(222, 218, 245, 1.0),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                color: Color.fromRGBO(222, 218, 245, 1.0),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.chat_bubble_outline_outlined,
                color: Color.fromRGBO(222, 218, 245, 1.0),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: Color.fromRGBO(150, 131, 220, 1.0),
              ),
              label: '',
            ),
          ],
          onTap: (int index) {
            // Adicione a lógica para lidar com os ícones do BottomNavigationBar
          },
        ),
      ),
    );
  }
}
