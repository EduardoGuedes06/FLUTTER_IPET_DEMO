import 'package:aplication/Pages/CartApp_page.dart';
import 'package:aplication/Pages/UserApp_page.dart';
import 'package:aplication/Service/UserCache.dart';
import 'package:flutter/material.dart';
import 'package:aplication/Models/Product.dart';
import 'package:aplication/Service/ProductsCache.dart';
import 'package:provider/provider.dart';

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
            fontSize: 45,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(16.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final Product product = products[index];
              return ProductTile(product: product);
            },
          ),
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
                  Icons.store,
                  color: Colors.red,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.shopping_cart,
                  color: Color.fromRGBO(255, 200, 200, 1.0),
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                  color: Color.fromRGBO(255, 200, 200, 1.0),
                ),
                label: '',
              ),
            ],
            onTap: (int index) {
              if (index == 1) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CartApp_page(),
                  ),
                );
              }
              if (index == 0) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ProdutosApp_page(),
                  ),
                );
              }
              if (index == 2) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => UserApp_page(),
                  ),
                );
              }
            }),
      ),
    );
  }
}

class ProductTile extends StatelessWidget {
  final Product product;

  const ProductTile({required this.product});

  @override
  Widget build(BuildContext context) {
    final userCache = Provider.of<UserCache>(context, listen: false);
    final carrinhoCache = Provider.of<ProductsCache>(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
      ),
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(
            'assets/wwwroot/Produtos/${product.image}',
            width: 120,
            height: 120,
          ),
          Text(
            product.nome,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16.0),
          ),
          Text(
            'R\$ ${product.valor.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 16.0),
          ),
          ElevatedButton(
            onPressed: () async {
              // Obtém o ID do usuário conectado
              final loggedInUser = userCache.getLoggedInUser();
              final userId = loggedInUser?.userId;

              // Adiciona o item ao carrinho com o ID do usuário
              if (userId != null) {
                carrinhoCache.addToCart(userId, product);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Produto adicionado ao carrinho!'),
                  ),
                );
              } else {
                // Trate o caso em que o usuário não está conectado
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Você precisa estar conectado para adicionar produtos ao carrinho.'),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              minimumSize: Size(40, 20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_cart),
                SizedBox(width: 3.0),
                Text('Adicionar'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
